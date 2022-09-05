Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268725AD199
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 13:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237401AbiIELcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 07:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236134AbiIELcT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 07:32:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADEA9FC1;
        Mon,  5 Sep 2022 04:32:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E39CA6123C;
        Mon,  5 Sep 2022 11:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19055C433D6;
        Mon,  5 Sep 2022 11:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662377537;
        bh=VjE4ycZgbfe3Q/I0AbmHrmQfNBPSGNwpWyu6mRKHtFI=;
        h=Date:From:To:Cc:Subject:From;
        b=tyfrRR4QYNZIim1PWrQxwNIQRKY2Sladk6YXAB1GkqG4m6kE/0aPuHjRNQ5+WR6f8
         uZuZfPUztVoVwDhgUboU4a+FOv7lC9wN1GL4xsMa8pdMkM4mGdSbSqNhfdXedvHBAI
         3Q5zTK65f9vUv4x6aj1wzOJmv/yNg6GOTitXwMp6zG1Vw7tvom5fKmQKkCERwDBUdB
         xSrvB7055UDQT2C4G0WsAfr+TOyfuLxixsttDjw19CxaWt9jN/zPVjBFDW65sdq73m
         x61tlzWzk1qoEuIUOeXqWPcso9ThTRBQBC3SeudagalRBmgIC3sB9k3LOUQd7/ap8c
         yePaXrGkmT3aA==
Date:   Mon, 5 Sep 2022 06:32:15 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     a.dibacco.ks@gmail.com, Cornelia Huck <cohuck@redhat.com>,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [bugzilla-daemon@kernel.org: [Bug 216449] New: vfio-pci calls
 pci_bus_reset whenever a pci_release is triggered and refcnt is zero]
Message-ID: <20220905113215.GA584198@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

----- Forwarded message from bugzilla-daemon@kernel.org -----

https://bugzilla.kernel.org/show_bug.cgi?id=216449

I'm using vfio-pci to map an FPGA. I have an utility program that gets a file
descriptor for the device and does an mmap to read and write registers.

When I close the utility the FPGA is reset and all registers are gone. 
I wonder if this is the correct behaviour, I understand that the
vfio_pci_try_bus_reset is performed only when refcnt reaches zero but, in case
of other drivers, like UIO the behaviour is different. 

I expected to be able to close my utility and restart it and find the FPGA
registers at the last configured value.

The vfio_pci_try_bus_reset is in vfio_pci_disable that is called by
pci_release.

Probably even a module parameter to prevent calling vfio_pci_try_bus_reset
could be useful.

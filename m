Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D201D656603
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 00:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiLZXUf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 18:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiLZXUc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 18:20:32 -0500
X-Greylist: delayed 419 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 26 Dec 2022 15:20:31 PST
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CE3F6C
        for <kvm@vger.kernel.org>; Mon, 26 Dec 2022 15:20:31 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 041F237DE24270
        for <kvm@vger.kernel.org>; Mon, 26 Dec 2022 17:13:32 -0600 (CST)
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id TwURIcYYRGid for <kvm@vger.kernel.org>;
        Mon, 26 Dec 2022 17:13:31 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 86C3437DE2426D
        for <kvm@vger.kernel.org>; Mon, 26 Dec 2022 17:13:31 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 86C3437DE2426D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
        t=1672096411; bh=pr4cQM4eXvDg8Yl5OHSz5bT5+1A9ogY0JIgXeSX5+Vs=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=cz2KXV4qALcPJg8KXeT8YDy2rJEwIn3HHJaQO+h2z2xvV3NKRDfdQuCU7kSvrUHDU
         9VgWkZjf8u0334uHOcyE51m1ilLk9azaW4A5vCfBJ1HbPK0p/o9as5KVIUHqKYG76a
         kSFDSPNGwkp8m0/E5R4axL8NbKgVNietnnkFDbRg=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id YUprAQL-hKHn for <kvm@vger.kernel.org>;
        Mon, 26 Dec 2022 17:13:31 -0600 (CST)
Received: from vali.starlink.edu (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 5FCF137DE2426A
        for <kvm@vger.kernel.org>; Mon, 26 Dec 2022 17:13:31 -0600 (CST)
Date:   Mon, 26 Dec 2022 17:13:31 -0600 (CST)
From:   Timothy Pearson <tpearson@raptorengineering.com>
To:     kvm@vger.kernel.org
Message-ID: <979527760.1710.1672096411263.JavaMail.zimbra@raptorengineeringinc.com>
Subject: VFIO-PCI stopped working on pc64le
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC108 (Linux)/8.5.0_GA_3042)
Thread-Index: T02bdho01enDx+F0Rf53QHu1yX3WtQ==
Thread-Topic: VFIO-PCI stopped working on pc64le
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When upgrading one of our ppc64el system (Talos II) from 5.18 to 5.19, we found that vfio-pci can no longer bind to the installed USB controller.  This issue persists into at least kernel 6.0.

The procedure to bind is as follows:

echo "104c 8241" > /sys/bus/pci/drivers/vfio-pci/new_id
echo 0003:01:00.0 > /sys/bus/pci/devices/0003\:01\:00.0/driver/unbind
echo 0003:01:00.0 > /sys/bus/pci/drivers/vfio-pci/bind
echo "104c 8241" > /sys/bus/pci/drivers/vfio-pci/remove_id

The result is:
[  220.792855] VFIO - User Level meta-driver version: 0.3
[  221.280523] xhci_hcd 0003:01:00.0: remove, state 4
[  221.280554] usb usb2: USB disconnect, device number 1
[  221.281115] xhci_hcd 0003:01:00.0: USB bus 2 deregistered
[  221.281134] xhci_hcd 0003:01:00.0: remove, state 1
[  221.281144] usb usb1: USB disconnect, device number 1
[  221.281148] usb 1-1: USB disconnect, device number 2
[  221.285611] usb 1-2: USB disconnect, device number 3
[  221.286197] usb 1-3: USB disconnect, device number 4
[  221.286203] usb 1-3.1: USB disconnect, device number 6
[  221.629920] usb 1-4: USB disconnect, device number 5
[  221.639087] xhci_hcd 0003:01:00.0: USB bus 1 deregistered
[  221.639343] vfio-pci: probe of 0003:01:00.0 failed with error -22

IOMMU groups are showing up correctly, the IOMMU is active and the only change was the kernel.  Falling back to 5.15.85 reactivates the support.

Is this a known problem?  Anything I can try to do to track it down?

Thanks!

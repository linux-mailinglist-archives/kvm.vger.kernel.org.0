Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F1365C4F0
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 18:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237765AbjACRRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 12:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238538AbjACRRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 12:17:43 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9674EFD05
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 09:17:40 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d3so33267846plr.10
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 09:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NmPU0DAPnTo9ly6c5vzl16QReWdT0lifTdN0mL7Hgqw=;
        b=giqvvDYlfx8gApA/qD/ejkru7bWOWjkxEcyBu+cvH3X6Spcul6ybRNW+zzEhNmxfK0
         QEkii7SWMyyjqOmZPhpx5IppYbeon5bwhB6t/JsGlJrULCxBFazNij5TY3lHSuba2eLG
         zm8kRq2TSFsdWevmf3zFQAyAyRUYq0ayhWyP+4BfxibeqjL7KxnqUxSo1UwcILVG7mni
         W7KP3Bt0p7dFmKOmZCHxR+ekzmBKWwwobFP2JA/lnOroJkYshMODk5W3+RvatZDNdWZH
         wiVW+GLM1FqAPFhblnIpf0ohD77BRAjTOVZjQWu8PNmG0H53x9NaW39rKNVLFFa7MxRk
         swBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NmPU0DAPnTo9ly6c5vzl16QReWdT0lifTdN0mL7Hgqw=;
        b=MKazgSuwm3LclWid5EXtn7AwFNLtzF6SL+GT1wynozD0Hfv9niHqYU89kqlO6CkYM1
         AmK5vzIqoJY7XUawm9FQOqEbb/gVG4WkldurzTc1Iz8pvDU/3OWIYxFlI78CvAXm/w5J
         DpbfSoTk7Dka2ug0Zn0t8qXd7IDAWYkjfXj308U2dPvZk5B3Wobh49BN+VfgnY7tfEDM
         EU6YjnBGuqQA263ZFTvVSPfRV6QJ2vwymNde9v4vUX/NOONCajbIh/5dw9vqq77PyzJY
         MegS5sn9JObqkftvjYpYHsTlS/F4YT/bCMBeKQ/EPpoy8f22c+XZdlTM5w/inFYw3Ba1
         uPwQ==
X-Gm-Message-State: AFqh2krXQq0riRReK49Yh7UQ7m2XhGhRtQji2HOOI9sduRPNVar+Q3aQ
        XlHytNr1ECBkylPMV/h+p4MVcg==
X-Google-Smtp-Source: AMrXdXsllXS/A4bjs7uKAjORnXNi/jMIv9YGGiPyRTrSrliuciBf4YnusJr/v4Ip0F9eIeNofiPG8Q==
X-Received: by 2002:a17:902:d4d1:b0:189:3a04:4466 with SMTP id o17-20020a170902d4d100b001893a044466mr4251734plg.2.1672766260000;
        Tue, 03 Jan 2023 09:17:40 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c10-20020a170903234a00b0017f73caf588sm22606911plh.218.2023.01.03.09.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 09:17:39 -0800 (PST)
Date:   Tue, 3 Jan 2023 17:17:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, dwmw2@infradead.org, kvm@vger.kernel.org,
        paul@xen.org
Subject: Re: [PATCH 1/2] KVM: x86: Fix deadlock in
 kvm_vm_ioctl_set_msr_filter()
Message-ID: <Y7RjL+0Sjbm/rmUv@google.com>
References: <a03a298d-dfd0-b1ed-2375-311044054f1a@redhat.com>
 <20221229211737.138861-1-mhal@rbox.co>
 <20221229211737.138861-2-mhal@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221229211737.138861-2-mhal@rbox.co>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 29, 2022, Michal Luczaj wrote:
> Move synchronize_srcu(&kvm->srcu) out of kvm->lock critical section.

This needs a much more descriptive changelog, and an update to
Documentation/virt/kvm/locking.rst to define the ordering requirements between
kvm->scru and kvm->lock.  And IIUC, there is no deadlock in the current code
base, so this really should be a prep patch that's sent along with the Xen series[*]
that wants to take kvm->-srcu outside of kvm->lock.

[*] https://lore.kernel.org/all/20221222203021.1944101-2-mhal@rbox.co

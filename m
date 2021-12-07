Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C9746C766
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 23:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241971AbhLGW31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 17:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238024AbhLGW30 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 17:29:26 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17031C061574
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 14:25:56 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id f125so393378pgc.0
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 14:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RQXmYAMR/sXSk9XmD70R29tOokpsn7xvqpKh45eus90=;
        b=AMfTYoLJN06fTTFwC2yJfyu6lGNUXEC17ykoxSfV2PycL8DftRMG5kABvLZCTOLPVr
         QxmNF6xTxHHmBsIitPiVNlFPBvlQ2GQup9roZL0McwoO4oc6HxCW08h2vPM+9XFPV6uf
         LhTN07hZOShLzPQ7h98ZzyALDfBbRequfAqum8odfrXdawrKzylOhwBOaSpvyGKaag6J
         XmSyJd4WL2Iarw0fv4BZjwZ4Awa5ku6jjqod9Wme2S9jL3vSqZXIWAuvf05VjC9HKSTN
         Rez6A+32yWy2XGfr8y8SkgUOkxHbej1lPRMVt6wTzLnHSs+2t0Uf5oKKp6OrQiUsLWuv
         +vtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RQXmYAMR/sXSk9XmD70R29tOokpsn7xvqpKh45eus90=;
        b=bAEVIJIeNEBkJCk/HlcsDu8J+NxD/Q7/A1BbffOd5wk9idSdjJ4oNCW6SuIxUx1GhG
         Uyt+B+kGhZO7CE0bvND1PdvV77Pheiwt+xn5FnRqWeCCzqJe7v7mQhxjxzy8ewwPvEPg
         CtlI5OtFGFxdtdgPHot6bgeOJS8jMOD12MeXA6ZF8P8Ak+Pml3+8ncF8EblxWJOQlEUF
         GL7S1FRDzreJUzTizzSbCNih97jIKPGWN9tYku81/gtbe7kyWMqY7b8uNXJRmijTpvPs
         eF8HKzGIYHdvNg73X8JRnBqCcquxNuu13X7Kal8sbq50jwHr8hDGQpb4QoHwUFX0HsuF
         APaQ==
X-Gm-Message-State: AOAM532l0MMpLtxp8PQSBGkMbbx3t+jrhe2yyco6dHiOgNlQNnue4JBZ
        4hxJ9BveW3weFETfiIRiIrJIyA==
X-Google-Smtp-Source: ABdhPJxQlLRiK0ua2RsOrTNvNVPEqsBLOWGVBdtjDau8f/z0OimiB1Zz37Y3lgjb700ozB120/xmQg==
X-Received: by 2002:a05:6a00:a23:b0:4a4:e9f5:d890 with SMTP id p35-20020a056a000a2300b004a4e9f5d890mr2050692pfh.82.1638915955458;
        Tue, 07 Dec 2021 14:25:55 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id on5sm526932pjb.23.2021.12.07.14.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 14:25:55 -0800 (PST)
Date:   Tue, 7 Dec 2021 22:25:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: dozens of qemu/kvm VMs getting into stuck states since kernel
 ~5.13
Message-ID: <Ya/fb2Lc6OoHw7CP@google.com>
References: <CAJCQCtSx_OFkN1csWGQ2-pP1jLgziwr0oXoMMb4q8Y=UYPGqAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtSx_OFkN1csWGQ2-pP1jLgziwr0oXoMMb4q8Y=UYPGqAg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07, 2021, Chris Murphy wrote:
> cc: qemu-devel
> 
> Hi,
> 
> I'm trying to help progress a very troublesome and so far elusive bug
> we're seeing in Fedora infrastructure. When running dozens of qemu-kvm
> VMs simultaneously, eventually they become unresponsive, as well as
> new processes as we try to extract information from the host about
> what's gone wrong.

Have you tried bisecting?  IIUC, the issues showed up between v5.11 and v5.12.12,
bisecting should be relatively straightforward.

> Systems (Fedora openQA worker hosts) on kernel 5.12.12+ wind up in a
> state where forking does not work correctly, breaking most things
> https://bugzilla.redhat.com/show_bug.cgi?id=2009585
> 
> In subsequent testing, we used newer kernels with lockdep and other
> debug stuff enabled, and managed to capture a hung task with a bunch
> of locks listed, including kvm and qemu processes. But I can't parse
> it.
> 
> 5.15-rc7
> https://bugzilla-attachments.redhat.com/attachment.cgi?id=1840941
> 5.15+
> https://bugzilla-attachments.redhat.com/attachment.cgi?id=1840939
> 
> If anyone can take a glance at those kernel messages, and/or give
> hints how we can extract more information for debugging, it'd be
> appreciated. Maybe all of that is normal and the actual problem isn't
> in any of these traces.

All the instances of

  (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x77/0x720 [kvm]

are uninteresting and expected, that's just each vCPU task taking its associated
vcpu->mutex, likely for KVM_RUN.

At a glance, the XFS stuff looks far more interesting/suspect.

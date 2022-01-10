Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB13489D36
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 17:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbiAJQMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 11:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237077AbiAJQMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 11:12:15 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875D3C061748
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 08:12:15 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso16300825pjo.5
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 08:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LQIBnFXycK0cJQSV4TX/MWC+qH4zFErUb+YLKkB6Pyg=;
        b=dzV7BFleQCUJTXWZp55i9EGrUy08ffr1RceWrnsKnVk6gbVlCelGPP1yzFSdkixz++
         IVMFXJMjvnH+B6Fp0tRrRAAcVC4pgJWVaAExoqnoTaYLZj/U3qoaa+GXsIX5zH/VZqZj
         nr47rTBv61q49IFz26pW86N+dEOMJxtisIbKnlPqgpRaYzMmtXwjPi67Nm1vhT7vU5PR
         Y6x86d4+wWgd5gqg6xWVebe3G+7JBXK7/HnD7SJz8cRB7It5Qxaa3o8uGAUB+ft91GIX
         T8EztjFPef10BPmQR24VjHZq3ojuABqFz9weNEZYHcR9jQzqmmOjC5Tb90IFvDT/JUjq
         xSWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LQIBnFXycK0cJQSV4TX/MWC+qH4zFErUb+YLKkB6Pyg=;
        b=mn64u1yEOlD44NX9z6LIdadrMoWO4aQj6jn9W/+NEEYSFacU9XcG+OzGl7y4pUE2kA
         BIf8/bfxGnKXBBYwEOtMZu62niFVLy/ZwMmli1kpedISSy3w4Q/tT79uuh4QghbflFph
         78NbPaESitqeSlkYUUK4CzLlNxWn2yuEHgCeBDiu4+oslJ7dVtH0OXV0quxP36sHNNEg
         AKD9+LiGdbkqluY3+u7Rj9AjsZCAm+dQCR8sVfPJdhTot2t1NfR5+eONizazKyEXIH1j
         Z7HT3B+/ewUfWn77OlX6/dkiXAJfGfh9G8t14Ax1I6c6HmKyeS28LBsYXDT1kkU9RqC4
         c0vA==
X-Gm-Message-State: AOAM5322tGII3H4+/OPq1+PEUejoQesjM477iqKELv+8aALA/UcnchyB
        0ZiowNcypqNi1TFwqYATnilPNw==
X-Google-Smtp-Source: ABdhPJwNX+rMaRrSQOVhxi1vkR2rD3412YcHYtYkXp/ZzKwQOu8TRybyGoOyaG+UXJUwAZHNqJbH8w==
X-Received: by 2002:a63:8c5:: with SMTP id 188mr368726pgi.13.1641831134951;
        Mon, 10 Jan 2022 08:12:14 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j16sm8053260pfj.16.2022.01.10.08.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 08:12:14 -0800 (PST)
Date:   Mon, 10 Jan 2022 16:12:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.liang82@zte.com.cn, ZhaoQiang <zhao.qiang11@zte.com.cn>
Subject: Re: [PATCH] KVM: Fix OOM vulnerability caused by continuously
 creating devices
Message-ID: <Ydxa2ndP/Qrggo90@google.com>
References: <20220108164948.42112-1-wang.yi59@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220108164948.42112-1-wang.yi59@zte.com.cn>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 09, 2022, Yi Wang wrote:
> From: ZhaoQiang <zhao.qiang11@zte.com.cn>
> 
> When processing the ioctl request for creating a device in the
> kvm_vm_ioctl()function,the branch did not reclaim the successfully
> created device,which caused memory leak.

It's not a memory leak, kvm_destroy_vm() => kvm_destroy_devices() will free all
devices. anon_inode_getfd() installes the devices fd, so the device's fd and its
reference to KVM will be put when the process exits.  Am I missing something?

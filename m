Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09EB368996
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 02:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbhDWAEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 20:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235302AbhDWAEU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 20:04:20 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BDFC06174A
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 17:03:43 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id p12so34002658pgj.10
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 17:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QWRme8W90t1BPTeoXEcFelQYikUvUd/HuwmVxLORM6Q=;
        b=gFBLejZmWYtwWuTbUzXrKVzwnRinJd2NDYaixKXbcMVTKTkTFJD5G29Fmaw6ukvp2g
         kiDQQ4mbkZlpkqSpolEsWqjz65mPpQLL9lGq2eDwRrSsLwSvKNRotY03yT1Ap/tPaHfm
         THy4S89Bpv6M0bNUc1JqdLBxFWELnuPQ1uhimcodJNU8zByseVj0EdUVRIKunkr/RGBB
         xhZP94F9yddMKYdyYH48PFjg/osYDJrhBB1+O/2+Qf3lIsQDE7A/qp0WvOlN+ceL+jrR
         fVWakjHTYnhrSZ7/8L4VwbmnQEJVMtVEHpKr9p+eEnb5z+NMC335lPmWT1dPoC8lC0Ty
         R4Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QWRme8W90t1BPTeoXEcFelQYikUvUd/HuwmVxLORM6Q=;
        b=c6LloF0oxARJJGAoJbVhntRzM87ETENH40uV8/NSSgE+Hnw9J3Nf8t4pprkZ2CrN/7
         Feiu+uw4QvvjJjL38CE0TScM77gu/nWn63RtuJdxkK1/oqnSo3iMgbgS1gOVKRn/18xW
         a31ftiEuXh8HSYd6MoKrso9zzVmFdyZjn1LfwEaQ2uVKoJNZTKYwrakrFTDTboLjL00M
         j4WsnSU7k/fMwugbGNcCJtB3hZp1vUvQfRQGAmEIeTj+wIoD0bv7NcjBHCT7Tx69Aq18
         gX4IS2gtQW3CWn5AzxZc9OEzET1dsKUjlio5MA2V/3tnjfKxQvwFSE34IfVQWdvHBXlb
         yH6w==
X-Gm-Message-State: AOAM533zNNYZCvEkfHa2lCJ8fO+pu3Q63WSG9nAAKHp/IOYsgDOED4AW
        vQu7Q3uI/G+v0RazIeoc+5sJ4Q==
X-Google-Smtp-Source: ABdhPJxEbZ7nzcHxEZ6WSTvN/ARrDhrTpdP+eAUgFOHzIyiWl+s74b+BkGvs5YUkzPirrG0+T9YwIw==
X-Received: by 2002:aa7:90d3:0:b029:241:21a1:6ffb with SMTP id k19-20020aa790d30000b029024121a16ffbmr1089728pfk.43.1619136223169;
        Thu, 22 Apr 2021 17:03:43 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id pc17sm3135335pjb.19.2021.04.22.17.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 17:03:41 -0700 (PDT)
Date:   Fri, 23 Apr 2021 00:03:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH 1/4] KVM: x86: Add AMD SEV specific Hypercall3
Message-ID: <YIIO0wtHeNK6pyri@google.com>
References: <cover.1619124613.git.ashish.kalra@amd.com>
 <c33adc91aa57df258821f78224c0a2b73591423a.1619124613.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c33adc91aa57df258821f78224c0a2b73591423a.1619124613.git.ashish.kalra@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> KVM hypercall framework relies on alternative framework to patch the
> VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
> apply_alternative() is called then it defaults to VMCALL. The approach
> works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
> will be able to decode the instruction and do the right things. But
> when SEV is active, guest memory is encrypted with guest key and
> hypervisor will not be able to decode the instruction bytes.
> 
> Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
> will be used by the SEV guest to notify encrypted pages to the hypervisor.

I still think we should invert the default and avoid having an SEV specific
variant of kvm_hypercall3().

https://lore.kernel.org/kvm/X8gyhCsEMf8QU9H%2F@google.com/

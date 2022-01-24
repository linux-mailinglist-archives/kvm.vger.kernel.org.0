Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAA9498546
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 17:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243946AbiAXQw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 11:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241220AbiAXQwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 11:52:22 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF009C061748
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 08:52:21 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id h20-20020a17090adb9400b001b518bf99ffso13802354pjv.1
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 08:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4DOMOYJSvvN5tnBDytVLTINey3QTpUnHaOAFRbqi0qA=;
        b=eOxxRt2pWH99m36u/u55DMJLDubxckBXickqh3FzfHWNuaYDbZbTaMzn7ptFPCdJVt
         8rYlwt9d5/MV2CVAa1Tvx9w255XzaXxs3chu0eZoC3rn1OUcuMKeSkNc7q4jxbZeB5gV
         hp+zPCL2Ziw+lyylMXAmk9LakpKKdTJ9Wc70E8kWXs52MwxLpGV7GvRfSZkR8oenjUx1
         ufne8AtTFjOwOkCS2imN8rl/XqP2He3ilTXCVsdjUBCTrxDkBRsVvy6mriDTXkXBUdmJ
         QVmsDJtwaEvxkiIj+LO1lbRAJu13iPL0ZatjQ6yLu7hxn+FkvNJf08gzaCYe5TSCxgr7
         4Tew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4DOMOYJSvvN5tnBDytVLTINey3QTpUnHaOAFRbqi0qA=;
        b=YUJS8VaSaS/Vx7xRA+N/jCZsNVirSq1eNSpjgTf4wyjAtEU68YeWDouM3eFe6Rn+CH
         7gmFw7ddBS8ZDNwcK+15OrBGAa7gUcuYM9Almw7IAC7fhYRK0nsNUztCFNyEGPVAXdXZ
         +b74E/gh3uOKT0KD5FsR45pz70Gma7HJSmT/eArufI/OWddLEyP+bFjxSfRUp4sM68kz
         RAcMyy9a0/AduEaY0+HCvBs/WeHgaIficF+lg5EBrCo0q91pluqiLfHKVhiDlZo8rCaY
         fxNe7jTxoqp7VuxJrZZ8uAjsHg+jf0Ttn4owE+dkj4SGwvMU6WhKcMrNuZT/QkTYLFE7
         Lu1A==
X-Gm-Message-State: AOAM530RpGzbdMSTy87l/t6bZzXoif/U9ogke5SdkinVs11OKr+rMYVI
        QtnfQ5Y+71Xm3ibqXo0ca2ier9Xk7Hn99w==
X-Google-Smtp-Source: ABdhPJyMr6O+G5WxooofruAM9cjUIrILwgimKxImnOMxYXRK8GJLu9w8hNxfYs9Rj7AXIu+opbzEwQ==
X-Received: by 2002:a17:90b:3ec2:: with SMTP id rm2mr2718033pjb.141.1643043141062;
        Mon, 24 Jan 2022 08:52:21 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k12sm17871572pfc.107.2022.01.24.08.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 08:52:20 -0800 (PST)
Date:   Mon, 24 Jan 2022 16:52:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Use memcmp in kvm_cpuid_check_equal()
Message-ID: <Ye7ZQJ6NYoZqK9yk@google.com>
References: <20220124103606.2630588-1-vkuznets@redhat.com>
 <20220124103606.2630588-3-vkuznets@redhat.com>
 <95f63ed6-743b-3547-dda1-4fe83bc39070@redhat.com>
 <87bl01i2zl.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bl01i2zl.fsf@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 24, 2022, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> >> +	if (memcmp(e2, vcpu->arch.cpuid_entries, nent * sizeof(*e2)))
> >> +		return -EINVAL;
> >
> > Hmm, not sure about that due to the padding in struct kvm_cpuid_entry2. 
> >   It might break userspace that isn't too careful about zeroing it.

Given that we already are fully committed to potentially breaking userspace by
disallowing KVM_SET_CPUID{2} after KVM_RUN, we might as well get greedy.

> FWIW, QEMU zeroes the whole thing before setting individual CPUID
> entries. Legacy KVM_SET_CPUID call is also not afffected as it copies
> entries to a newly allocated "struct kvm_cpuid_entry2[]" and explicitly
> zeroes padding.
> 
> Do we need to at least add a check for ".flags"?

Yes.

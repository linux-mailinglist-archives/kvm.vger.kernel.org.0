Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF55383B76
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 19:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236443AbhEQRkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 13:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236087AbhEQRke (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 13:40:34 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D028CC061573
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 10:39:17 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id q2so5430046pfh.13
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 10:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hvub6CXwv1swv1fPBWV3j29OzzOASCX1eigrFawcdJA=;
        b=MXSffpKw04H3Myy+0OBpJX1eRwj4cYwVMw47+31Z9xzgcAtyA5P1sJKI/NVjE9DhP2
         m9Uo/i/WyPaRIV73zK40aQhGdfZXXNs75uT2eQbi//h9KgLue9kZQ5KUW6pbFDcBiZYG
         w8eW52GVY5phUQIP6ASC5EOwf/wTjXLFCS0A8sWldQMdDy/UPFAtrMZVtfH+08TjPrmw
         kWD5kxDctKfXEsQBcco7moW4P8oa+NXQhbp0wFW8D4hpkgbNLETdpwWrQUeND/Un6xsa
         9cn8vsAyu1lxKhlVu/bCAfTOu0EGLLCBYy3Xlfi3KjzId2qfkePAybrNPtrNeaIyyaTm
         wBKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hvub6CXwv1swv1fPBWV3j29OzzOASCX1eigrFawcdJA=;
        b=EifbbZcibKFNiQqEmqvrp7+J7DyrGZZa2m9hOXRKrT+5Eu/UvH0ljQ4ebEvWUG8aUv
         GAKB1HwN1f6Opci0mlbUec1uS4jGY0ZloJB85TF+yp07gt2uNKH2BwZFvYurrhaSrEyN
         MQfUmbheTexw6ugrPrRmqVkI4cF5/jMjCpLQGwUfkLe+DZoH7BoHZBficXPqy1rlI4bb
         62ZbPRDxSgVuX401tJnjIV1r0nQQpCMcHO2f85znb4wTYLXO//gJGC306PGdUds8cScN
         T0jNqXHPsWQ4DoxoN9q3I16BtDJFKYLkJSzJ1jF7lc8HSep+dxPQGKRZLUVztPFVSD60
         gxaw==
X-Gm-Message-State: AOAM531VnEZmNZN+6n9+RlJdn4mTB21a9LSF5LWD89rTqVkZsIrFuRDD
        1tGxXISF1rZvSiocd6iMXBDDkA==
X-Google-Smtp-Source: ABdhPJyPw5UV6J978V3Si3HhKjvcrULfDqvYAgy5AE7RccNMNlTjfVEHILrs+ULlrqM+9B6iKQbqNA==
X-Received: by 2002:a63:9c7:: with SMTP id 190mr659228pgj.149.1621273157269;
        Mon, 17 May 2021 10:39:17 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id p1sm10080539pfp.137.2021.05.17.10.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 10:39:16 -0700 (PDT)
Date:   Mon, 17 May 2021 17:39:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>, Jon Kohler <jon@nutanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Juergen Gross <jgross@suse.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: add hint to skip hidden rdpkru under
 kvm_load_host_xsave_state
Message-ID: <YKKqQZH7bX+7PDjX@google.com>
References: <20210507164456.1033-1-jon@nutanix.com>
 <CALCETrW0_vwpbVVpc+85MvoGqg3qJA+FV=9tmUiZz6an7dQrGg@mail.gmail.com>
 <5e01d18b-123c-b91f-c7b4-7ec583dd1ec6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e01d18b-123c-b91f-c7b4-7ec583dd1ec6@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021, Paolo Bonzini wrote:
> On 14/05/21 07:11, Andy Lutomirski wrote:
> > I don't even want to think about what happens if a perf NMI hits and
> > accesses host user memory while the guest PKRU is live (on VMX -- I
> > think this can't happen on SVM).
> 
> This is indeed a problem, which indeed cannot happen on SVM but is there on
> VMX.  Note that the function above is not handling all of the xstate, it's
> handling the *XSAVE state*, that is XCR0, XSS and PKRU.  Thus the window is
> small, but it's there.
> 
> Is it solvable at all, without having PKRU fields in the VMCS (and without
> masking NMIs in the LAPIC which would be too expensive)?  Dave, Sean, what
> do you think?

The least awful solution would be to have the NMI handler restore the host's
PKRU.  The NMI handler would need to save/restore the register, a la CR2, but the
whole thing could be optimized to run if and only if the NMI lands in the window
where the guest's PKRU is loaded.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B266743B1
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjASUvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjASUuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:50:44 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2AA4C2B
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:50:43 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id a4-20020a5b0004000000b006fdc6aaec4fso3544255ybp.20
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I5zKIgdYxLOeIw+F0RNN/Gej7dLsvMuoifdDKOUDvn8=;
        b=bfk8GfyqJ7JqDF4/qX9DAE8lNvs2ToBrLSEIek8c1xehWOtV7FDrMbE5/P+Pcc31pt
         4o/2T/juZKOkEAeQEFMjl7cd3kqvkrAnY1idI44/B1aDhDMwhSZca6BD/7FqplSxAFzL
         Rm36/WlSC10KKls+ow+5fIGpkrL4VimFnoRRKjiIzR2RpOrE+4JB4dTlQNUdMkx1E3vt
         fSO61ImCFbVxMOPAFVFKwgrilXgBWv/oNSDl92yCm82P0m38nRjsO8OL47fDRgBJlB3a
         iexE95ZxSh6DQw9SqW5KqrYp/NblNC8x2ZrE+Ljq4PwNWRjXa802D30gdEGlYQjlgQro
         RfHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I5zKIgdYxLOeIw+F0RNN/Gej7dLsvMuoifdDKOUDvn8=;
        b=OfHi4AzM5dEbuBRDW1sY2rwWCdEhhbk6VCIaDvSsW04j0GVUMjWJz1QjvPfJzDypIT
         XpKgPDh6SrGKei1tRYtpSH/sdLsPi3XfqgWBWnwOuS0MtROfSFvhMmdzMOWg7QJvgNf+
         BTe8nEYK0tZijNQWhFbJ2Ge4EmWd5j7EQLAen440Gzrukb+SeK6izTrm7JJMGlQMBBU1
         QtnqYIyeLNDriCj7Gb979CH8uDG7IwdoEcTTKCVEbhTfj0Z+pOqcJsskiXzK+mnFDEnm
         wkakA5KBOz+Xm3B/eWHjAYC3lABIwPVzRJRU70y1c42rDTTJtp/IZRVV0DZYOJtVqV6M
         Pi5g==
X-Gm-Message-State: AFqh2kpd7pbCc7nv6j6AvN8Z3aQK4ryAZjK5es4ARl+nZoLtRNi/zOAJ
        3kUd2b6j72waSC4T5Q+M2RZQxm7JSew=
X-Google-Smtp-Source: AMrXdXvdAmawkY65N0z8ChOhh03gGqiCHYC0ZxDh4xBZrwQh4i+3/4czj/veJ3RvoTtxKatt9dQA1juQd1I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:d248:0:b0:4ce:b871:b32f with SMTP id
 m8-20020a81d248000000b004ceb871b32fmr1502469ywl.328.1674161443092; Thu, 19
 Jan 2023 12:50:43 -0800 (PST)
Date:   Thu, 19 Jan 2023 20:48:50 +0000
In-Reply-To: <20220901211811.2883855-1-jmattson@google.com>
Mime-Version: 1.0
References: <20220901211811.2883855-1-jmattson@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167409017216.2371531.17640004005999578366.b4-ty@google.com>
Subject: Re: [PATCH v3 1/2] x86/cpufeatures: Add macros for Intel's new fast
 rep string features
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Wyes Karny <wyes.karny@amd.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 01 Sep 2022 14:18:06 -0700, Jim Mattson wrote:
> KVM_GET_SUPPORTED_CPUID should reflect these host CPUID bits. The bits
> are already cached in word 12. Give the bits X86_FEATURE names, so
> that they can be easily referenced. Hide these bits from
> /proc/cpuinfo, since the host kernel makes no use of them at present.
> 
> 

Applied to kvm-x86 misc, thanks!

[1/2] x86/cpufeatures: Add macros for Intel's new fast rep string features
      https://github.com/kvm-x86/linux/commit/751b1e1ee8e9
[2/2] KVM: x86: Expose CPUID.(EAX=7,ECX=1).EAX[12:10] to the guest
      https://github.com/kvm-x86/linux/commit/bbbe171ac12f

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes

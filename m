Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C19C4B73C9
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 17:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241710AbiBOQkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 11:40:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241690AbiBOQkR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 11:40:17 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA540F1EAE
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 08:40:07 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id x4so13514897plb.4
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 08:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GjzGhBOh8jK25Hj15polj7Q2qGK/jzjkg+lJ5DCE9Bs=;
        b=mDwJxlM9ua3Q2EgY+L5cfx6nvP4xPP+V5PVHN/8DFq6tukufpnQnRJFRhRH+X1Kg2g
         7yYY6qmmd/2hMLGnJj75Yoww4EO20Uj5zU/pEhf5S8Bdr74ZZGkiRWnOlSGGQldMtnC2
         v/cbHY8fGp1O7j7LN65MwzB40H7TV+ABMpVILP6pEhtkKCVIt0JQviHRDltnyeifZxLw
         BEPuP5UFkVICiZKm/uv/71YmeDwxxKLbVFfNzkNgSe3ro8V+eHbWWL7dQvXY4KoB9wrc
         hAiv0sAKz3QnPf/sZ0ZfmS1SMjQU4Gg/cIE+ByBPlcNvCO1sY7N1GxjQn2HRwjghj0Oh
         HPAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GjzGhBOh8jK25Hj15polj7Q2qGK/jzjkg+lJ5DCE9Bs=;
        b=O6cD/aJKFcXJm8lvoIdRZRLlhhbwZ+iyTG77RrZ5AekwJ/TAHdhY0ojdI89sUQ81cy
         PZsStlq1S/G7nxm+/3Ab73TRVg1WDoyG+FKqfnvmFu/6HHXfUo8DrRxzIcsOhDEuL4Ek
         N/qWbOOaxTCgjIrGwdwNJ2BBFdvr1A6yjK8hgcF8JjyeIl6FQe6afPVdNrwJZZ5hFjD1
         bUyShy5Z6LvkHeBSzP4LuiYkWpt4gB9U0yyXL059SXqIhtec3xerVzz5aW4bPoo5D5Uy
         hLnIBuS5pis4L8W7bJU9/CnmGm6BTmc0783bh5FdH/0bLl10Ry0L7CvdO9jFcoEG/cXb
         745g==
X-Gm-Message-State: AOAM530ueI4b4BUegZze3b3oolvmOz6kRhFqYvn+YQoXweizhpbgSA0t
        WGnuvR2Uo+vcw5uC63uthUCn0g==
X-Google-Smtp-Source: ABdhPJzp3QQbBsaFv+7+b6FImzl1ZX+uzkVQdvAA7LZJnDAJM8bbYxLOXQYZ8csVnKZYU87zVSDD6g==
X-Received: by 2002:a17:90b:4f42:b0:1b9:5a43:2278 with SMTP id pj2-20020a17090b4f4200b001b95a432278mr5313268pjb.158.1644943207065;
        Tue, 15 Feb 2022 08:40:07 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id oj10sm18803477pjb.7.2022.02.15.08.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 08:40:06 -0800 (PST)
Date:   Tue, 15 Feb 2022 16:40:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 09/11] KVM: x86: Treat x2APIC's ICR as a 64-bit register,
 not two 32-bit regs
Message-ID: <YgvXY98ah4uIECee@google.com>
References: <20220204214205.3306634-1-seanjc@google.com>
 <20220204214205.3306634-10-seanjc@google.com>
 <20220215032712.GB28478@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215032712.GB28478@gao-cwp>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 15, 2022, Chao Gao wrote:
> > 	case APIC_SELF_IPI:
> >-		if (apic_x2apic_mode(apic)) {
> >-			kvm_lapic_reg_write(apic, APIC_ICR,
> >-					    APIC_DEST_SELF | (val & APIC_VECTOR_MASK));
> >-		} else
> >+		if (apic_x2apic_mode(apic))
> >+			kvm_x2apic_icr_write(apic, APIC_DEST_SELF | (val & APIC_VECTOR_MASK));
> >+		else
> 
> The original code looks incorrect. Emulating writes to SELF_IPI by writes to
> ICR has an unwanted side-effect: the value of ICR in vAPIC page gets changed.
> 
> It is better to use kvm_apic_send_ipi() directly.

Agreed, the SDM lists SELF_IPI as write-only, with no associated MMIO offset, so
it should have no visible side effect in the vAPIC.  I'll add a patch to fix this.

Thanks!

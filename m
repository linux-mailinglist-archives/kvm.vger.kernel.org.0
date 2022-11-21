Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9414632D44
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 20:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiKUTu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 14:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiKUTu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 14:50:27 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FDDC663F;
        Mon, 21 Nov 2022 11:50:26 -0800 (PST)
Received: from zn.tnic (p200300ea9733e725329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e725:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1F4DC1EC03EA;
        Mon, 21 Nov 2022 20:50:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669060225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=vS6hQXXKdamlj388PigRtgSnQnMEFa/3mJnTXAFDmmM=;
        b=AipnRmCdTmNC+wFMuqXonf3nPbXeQH0DHrna+LeyNPM9zCA0Yb07Q7wTTf8IcjSkNk+ZZG
        3enb3NU7maDMdBf0LsWARczui1ZjmgbziA1Acq3ffiVbsfAv8elHvEZkmqDC9/A7bad3RT
        YI5eIHDyPY0dGtKYSJ/Gtz1CLFIltCg=
Date:   Mon, 21 Nov 2022 20:50:24 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        ndesaulniers@google.com, alexandre.belloni@bootlin.com,
        peterz@infradead.org, jpoimboe@kernel.org,
        chang.seok.bae@intel.com, pawan.kumar.gupta@linux.intel.com,
        babu.moger@amd.com, jmattson@google.com, sandipan.das@amd.com,
        tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        fenghua.yu@intel.com, keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/6] x86: KVM: Advertise CMPccXADD CPUID to user space
Message-ID: <Y3vWgK/Vr94zGS3S@zn.tnic>
References: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
 <20221118141509.489359-2-jiaxi.chen@linux.intel.com>
 <efb55727-f8bd-815c-ddfc-a8432ae5af4e@intel.com>
 <f04c2e74-87e4-5d50-579a-0a60554b83d3@linux.intel.com>
 <6d7fae50-ef3c-dc1e-336c-691095007117@intel.com>
 <Y3udtm6oC7k41kaR@google.com>
 <Y3ue4PoJD7EGC5dV@zn.tnic>
 <Y3u1Rx/kFjE5/FFR@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y3u1Rx/kFjE5/FFR@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 21, 2022 at 05:28:39PM +0000, Sean Christopherson wrote:
> Yes.  Most userspace VMMs sanitize their CPUID models based on KVM_GET_SUPPORTED_CPUID,
> e.g. by default, QEMU will refuse to enable features in guest CPUID that aren't
> reported as supported by KVM.
> 
> Another use case is for userspace to blindly use the result of KVM_GET_SUPPORTED_CPUID
> as the guest's CPUID model, e.g. for using KVM to isolate code as opposed to standing
> up a traditional virtual machine.  For that use case, userspace again relies on KVM to
> enumerate support.

Ah ok, thx.

/me makes a mental note.

> What I was trying to call out in the above is that the KVM "enabling" technically
> doesn't expose the feature to the guest.  E.g. a clever guest could ignore CPUID
> and probe the relevant instructions manually by seeing whether or not they #UD.

As can a nasty userspace on baremetal. That's why /proc/cpuinfo is not
really the authority of what's supported and we're going away from
treating it that way.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

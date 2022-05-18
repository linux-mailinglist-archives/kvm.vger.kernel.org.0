Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B5E52C056
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239997AbiERQQo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239971AbiERQQn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:16:43 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E89A76D1
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 09:16:41 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id w17-20020a17090a529100b001db302efed6so2539422pjh.4
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 09:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=27J+LsUtyeeYy/GvJkk2tphV2jBbsCOsrmpZjooJvdA=;
        b=WsFMsQRAqPFYtDRXv1eq/d16y4WXmvGrQzz4CAO9ARgrPBnZudm/BdIonig9LJyFcm
         x6L1zSSnkCAOWz2YA0yASGUB+S/LnV93goRZsCwFI/c0oM6Wt6HovjUhwpPIhHwnAmgf
         0UULa2rgpV/0NpYuJBZ1n9Y7Z3J0NyCqw3cQu4ZP70oCUpqlb8b8MsNZ0F22EDY2ZbA3
         5E1hyQWNsllEe7cLvGs3pzHDGEMwvrxA4n0ilcZn7OsnEXZa9Xik24fr3nohv7oQ4WX1
         CW6+uDBt2U+dmO+Q5ct+H8Au3VCnLrnBY51f3Z4vRidqf2HwVg5OVps7L3et5gtGQ2aA
         EKFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=27J+LsUtyeeYy/GvJkk2tphV2jBbsCOsrmpZjooJvdA=;
        b=qmgVK+8DaV6GEnWVnh/8TJZzVDqQ/5fCJjfEXJN3wg1AHru1iqrXGKGbbrhl5Vs9Xb
         eqIKFyIFUBQw0Q7+Kq4cNUe0YmO8QG3mWilN0jCMRynqqLZCGM/dmLMt5mPNwc5pRiws
         KYigDihyj2KX88ip2j++Zab9xhcz2KnUxZohu0tx6z1OQWyO/B3dLlTm5S4YqPj4HYJx
         Y0w0mebQr387Jx4f8/X7HikER0VgkXRe4VUHwY5xbVL+xPDzIonDgkju0GRLxnxrIBmR
         ceGA1EAsUz+z4ckDI6yF+rqcav+hsTD4cpp9RSO0kDOh0OfrbeJ3JQp4ln6BB08QX+Xo
         OhOg==
X-Gm-Message-State: AOAM533/VidAfBjnPUfQt2TiXyRt1DlIFhkxUfSiw46Y4X/EL3IcNE0J
        HH6U64q2H42METT38iTBgH80hQ==
X-Google-Smtp-Source: ABdhPJzlMzaxzyxYIp0EtYqROS3OrIc3ty0dMgOLbrexh3oQF/2zOIfjp3/5KS2qx0kdvnbCWlOOjg==
X-Received: by 2002:a17:90a:7441:b0:1df:5f54:502c with SMTP id o1-20020a17090a744100b001df5f54502cmr770638pjk.129.1652890600319;
        Wed, 18 May 2022 09:16:40 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 4-20020a170902e9c400b0015e8d4eb264sm1893016plk.174.2022.05.18.09.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 09:16:39 -0700 (PDT)
Date:   Wed, 18 May 2022 16:16:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     John Allen <john.allen@amd.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v15 07/14] KVM: VMX: Emulate reads and writes to CET MSRs
Message-ID: <YoUb4/iP+X+xgsfQ@google.com>
References: <20210203113421.5759-1-weijiang.yang@intel.com>
 <20210203113421.5759-8-weijiang.yang@intel.com>
 <YoUW4Oh0eRL9um5m@dell9853host>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoUW4Oh0eRL9um5m@dell9853host>
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

On Wed, May 18, 2022, John Allen wrote:
> On Wed, Feb 03, 2021 at 07:34:14PM +0800, Yang Weijiang wrote:
> > +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> > +		if (!cet_is_ssp_msr_accessible(vcpu, msr_info))
> > +			return 1;
> > +		if ((data & GENMASK(2, 0)) || is_noncanonical_address(data, vcpu))
> 
> Sorry to revive this old thread. I'm working on the corresponding SVM
> bits for shadow stack and I noticed the above check. Why isn't this
> GENMASK(1, 0)? The *SSP MSRs should be a 4-byte aligned canonical
> address meaning that just bits 1 and 0 should always be zero. I was
> looking through the previous versions of the set and found that this
> changed between versions 11 and 12, but I don't see any discussion
> related to this on the list.

Huh.  I'm not entirely sure what to make of the SDM's wording:

  The linear address written must be aligned to 8 bytes and bits 2:0 must be 0
  (hardware requires bits 1:0 to be 0).

Looking at the rest of the CET stuff, I believe requiring 8-byte alignment is
correct, and that the "hardware requires" blurb is trying to call out that the
SSP stored in hardware will always be 4-byte aligned but not necessarily 8-byte
aligned in order to play nice with 32-bit/compatibility mode.  But "base" addresses
that come from software, e.g. via MSRs and whatnot, must always be 8-byte aligned.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF4F307AF9
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 17:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhA1QaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 11:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbhA1QaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 11:30:18 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA901C061574
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 08:29:37 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id h15so3608570pli.8
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 08:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QnW3q9QyfBy23IUUBbxB1+tEoGYrf3OEFE1JiHhnYNI=;
        b=DRwK5JqFq7BywQ4Vm9vUysjNAG9F3h2O5beySmJlaCPbrr+5Qu46bjg5kRmaLQF4gf
         rPPssfHJt7fgEoZDu6udCsswj+BWZFIdQRn57cd7N8+7UIOz/LIafNaYOefbmSjq3pwx
         GT5AMtIWl5+3ImH1zsy9mVUQcCJdoriQROM97OO0uKwdfs2AZWsUZJjbTmtjn+lnA7VF
         qmUByziV2yfYrznILz+NhPwbHvs7YM42HnyD2GVZ4zi5kqW5XjlaWPoGBkZ1ggSLx29B
         UKvKOpgtQ3pheXwXvXT/67HP2avtCsaaqf4F1x0LtzarAEwcm6nwu8eAm2No2RRpHfnG
         F5hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QnW3q9QyfBy23IUUBbxB1+tEoGYrf3OEFE1JiHhnYNI=;
        b=m0n2xQuchsFppv+CPl8oO03S/EAyxlTbQ70xQ8dWHTzIIZvFSD2y9eKW3sTVt892Yh
         7EbfOpStMaG84a4mfBQwtSeUkFY/clfOKBE7IsclHwqNkTW+0N2i1muUmjBTd72lDgxB
         v/6zVCcTwIS1PKNQzu0LQG/Wf451f00Iv8slbfBxES2CqmexZ6DYLyxrkiuALldLyLMo
         9dsbrV2rxc2IzBGLmBlBi7UUDu0OtUlA/zp+UnXWT1T5KJ85C0glp7hn3oCgX2FQSSjS
         ydHD1x2NYbS+KGs3hgfdRlA5V6a+pePYENvpaBU3qvtccGhF6nvrk+dgPVFfJGP9bB2/
         0ZbA==
X-Gm-Message-State: AOAM532unMIh4SD8aPSlEiv01wSLlAuQBXXGv+kzsyz9Doh3YdVwXRek
        z7q4LJhacGz54M37qlZJuTSjng==
X-Google-Smtp-Source: ABdhPJwS2mNBw4warJqPOhYSugBs698YhL8w0kJ0zbQCzWy46eJPFTumY+EVRNujxC7cFEkpJvvHbQ==
X-Received: by 2002:a17:902:b212:b029:df:ec2e:6a1f with SMTP id t18-20020a170902b212b02900dfec2e6a1fmr185717plr.24.1611851377109;
        Thu, 28 Jan 2021 08:29:37 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id n8sm5715265pjo.18.2021.01.28.08.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 08:29:36 -0800 (PST)
Date:   Thu, 28 Jan 2021 08:29:30 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2 14/14] KVM: SVM: Skip SEV cache flush if no ASIDs have
 been used
Message-ID: <YBLmareW9CB0Kcta@google.com>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-15-seanjc@google.com>
 <55a63dfb-94a4-6ba2-31d1-c9b6830ff791@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55a63dfb-94a4-6ba2-31d1-c9b6830ff791@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 28, 2021, Paolo Bonzini wrote:
> I can't find 00/14 in my inbox, so: queued 1-3 and 6-14, thanks.

If it's not too late, v3 has a few tweaks that would be nice to have, as well as
a new patch to remove the CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT dependency.

https://lkml.kernel.org/r/20210122202144.2756381-1-seanjc@google.com

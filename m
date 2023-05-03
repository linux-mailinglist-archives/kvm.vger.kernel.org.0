Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD9E6F6220
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 01:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjECXiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 19:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjECXiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 19:38:06 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609C58A6C
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 16:38:05 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-55a40d32a6bso47072407b3.2
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 16:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683157084; x=1685749084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=33bXKWTsrMeKsukezlTXuHQlkcPPhfXNP6e5V4bHmvI=;
        b=qM/uMsZFWYbuK2lDHRz2izJTVAAKO/SxvWHJKel6p4daomUiSzq02htji3eIEjBAKJ
         f+jD0yTDRdntw5HVKm6VgnyHcYSe2oToTzKnAgLIQu4CXKloTapegHMYuFkKuvAUs4OG
         VVuf5jsoozKGudFCoGGRNv/nvjnjDtE5woFDkQyyFOKNOMdXG2CuPmUVoCe8kRtLe8d5
         fdMA7kSCGBN1O/raWixjjoDUlblzI6XBtU8+3dy56AuVhEsWsumqQn8oybQmrNbNUmMC
         vbKhx/P65OOUp2nCUiFnxTuMVhJrvcditCJxHk2fFxRAtD2xMDI3Yz9IANGbDTAkjR2l
         h2Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683157084; x=1685749084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=33bXKWTsrMeKsukezlTXuHQlkcPPhfXNP6e5V4bHmvI=;
        b=Q3JLYtyXHW4RaZwip4AGaQEeT5+xShkvT9g8eEEiJ9okmub55e4eT7KaMXgeCWSlaV
         h5U1k59GQ02jtbuu53bYlcOCDYAw/HQbsWKkIzG8khX+VMt3aCo3WApOn3rDx/5CzR9W
         3qMquRNIV93PvJv0X7QkyI/plyHMfeTpp7Kbe8SVvEHircdeCepdkt2UgR7K9kqBycyJ
         ZK3Hf2jbnde99AZBWyh3XLXl/+ucoj3oSADwp0i3JAQW5bDRbUSPlXQbpj6OAGM3Lc4y
         fDhENgrUHmy1WwHrsVdFVjibrDf2ecTTpUP89WSOTBxvWfA/xYWyExiwfZ2Vf8PPqYEr
         QVnQ==
X-Gm-Message-State: AC+VfDxjhzmQ+HBYnyDCD9yS/ySoYZxCZaCAQDzhJZUefKPVLrOi40cb
        xehiWkYvnu1LEQVHplGVKhqbYtZWiSg=
X-Google-Smtp-Source: ACHHUZ7K4eu0EedAW9QXpxUN8SonlCYJpd+9BpnXcTcToLufihzeQkk3V1/4v85cRolNIFTlYkLbxTeldnE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:440f:0:b0:552:b607:634b with SMTP id
 r15-20020a81440f000000b00552b607634bmr172700ywa.4.1683157084710; Wed, 03 May
 2023 16:38:04 -0700 (PDT)
Date:   Wed, 3 May 2023 16:38:02 -0700
In-Reply-To: <47e0d0cd1452383646a2cc9972f765b469fc51a6.camel@intel.com>
Mime-Version: 1.0
References: <20230503182852.3431281-1-seanjc@google.com> <20230503182852.3431281-5-seanjc@google.com>
 <47e0d0cd1452383646a2cc9972f765b469fc51a6.camel@intel.com>
Message-ID: <ZFLwWtDTaiyxdjMV@google.com>
Subject: Re: [PATCH 4/5] KVM: x86: WARN if writes to PAT MSR are handled by
 common KVM code
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 03, 2023, Kai Huang wrote:
> On Wed, 2023-05-03 at 11:28 -0700, Sean Christopherson wrote:
> > WARN and continue if a write to the PAT MSR reaches kvm_set_msr_common()
> > now that both VMX and SVM handle PAT writes entirely on their own.  Keep
> > the case statement with a WARN instead of dropping it entirely to document
> > why KVM's handling of reads and writes isn't symmetrical (reads are still
> > handled by kvm_get_msr_common().
> 
> Why not just merge this patch with the next one?

Hmm, good question.  IIRC, I originally had the last patch delete the case
statement and so wanted a bisection point, but I agree that having this as a
standalone patch is silly.  I'll squash it with patch 5 in v2.

Thanks!

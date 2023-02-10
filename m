Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F56E6915F4
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 01:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbjBJA7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 19:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjBJA6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 19:58:37 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FBB2798D
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 16:57:08 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id nn4-20020a17090b38c400b00233a6f118d0so1131374pjb.2
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 16:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a4nOHQKii0NnhZ2y15hr0yyiLoRCKn4ROIP7SIgW9vw=;
        b=HgZWk5Ps3YFz8QW9nCkWKxRHwz/lITw02v3VFKkG7HraHsQqyqQrfMNfEECH7zpzGM
         LVaCcmgb8pbUIrAMAFxq4UkYicVZmxF5+XnAKjQ+RFDN1v1T47XsHEmECKaWDaRgXloF
         D242jY3tXln1/1nJldzKIVq/FNROY9XDDBjki35UVO+NwlEMS/658RTS8lmPwQkHOBFA
         X15f6HNCD2CAYnU0SnXZMxze0r39JqyqrscasnU5j5dRo376My+XDBoEB2l2CHayObMY
         sriB6rG+tPderPz6sY2Aw8pHvihpJwLTIpDkGiQx2mI+3MZmQL4Xw8PWU//kPM4W3j1L
         Cthg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a4nOHQKii0NnhZ2y15hr0yyiLoRCKn4ROIP7SIgW9vw=;
        b=1qOVeHc2duqduJYW6UXBQ9afqdiqinhf5KkIgbgtT13bhdp7cuaIg/fVJsYdFu6OFi
         aOytunXaxK8jB33fZMW2yBdjezJjB9ERW2hEDdJ8Kcd3ISt40cFis37/wuz8W6DFejGs
         raAXSLgxm2UzZd+19PhbUi2ol1CdNKYc4mp9rRPFkaFjfuI9qGQxratyVZtPRE84IdFW
         buESYhYN0jGs1LJjCjDp23pksoVnpbxsvQppC0za14yjds2hByOAN4QOTS7Y9Gxl8o20
         yraFkuoKHf2LOwoIb/ybcPusMqAVqdMuyzygrU1qe/dBRX+t5K6toVX8hypDCl200QO+
         UYWw==
X-Gm-Message-State: AO0yUKXC2wHd/W0Pbu/WYnnrc0YDxgjL1ragcv1SDSqYcI5RB5VJnoNq
        oECXxJBVDz6ICxBk+LKtM27guA==
X-Google-Smtp-Source: AK7set8p9g0yFBoUfNShzpD1+YavEPBqDuh6eKiZHotMm/2TKF9RoD5R/xTHYgZnvshIN5VVtsfgew==
X-Received: by 2002:a17:902:b497:b0:199:3909:eaee with SMTP id y23-20020a170902b49700b001993909eaeemr101876plr.6.1675990627619;
        Thu, 09 Feb 2023 16:57:07 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x1-20020aa784c1000000b0058e1e6a81e8sm2061791pfn.38.2023.02.09.16.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 16:57:07 -0800 (PST)
Date:   Fri, 10 Feb 2023 00:57:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: Re: [PATCH V2 4/8] kvm: x86/mmu: Set mmu->sync_page as NULL for
 direct paging
Message-ID: <Y+WWX79I3acL1h5S@google.com>
References: <20230207155735.2845-1-jiangshanlai@gmail.com>
 <20230207155735.2845-5-jiangshanlai@gmail.com>
 <d5ff098a-731c-f336-efd4-b7405c5e776e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5ff098a-731c-f336-efd4-b7405c5e776e@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 07, 2023, Paolo Bonzini wrote:
> On 2/7/23 16:57, Lai Jiangshan wrote:
> > From: Lai Jiangshan<jiangshan.ljs@antgroup.com>
> > 
> > mmu->sync_page for direct paging is never called.
> > 
> > And both mmu->sync_page and mm->invlpg only make sense in shadowpaging.
> > Setting mmu->sync_page as NULL for direct paging makes it consistent
> > with mm->invlpg which is set NULL for the case.
> > 
> > Signed-off-by: Lai Jiangshan<jiangshan.ljs@antgroup.com>
> 
> I'd rather have a WARN_ON_ONCE in kvm_sync_page(), otherwise looks good.

Agreed, there's even a WARN_ON_ONCE() to piggyback:

	if (WARN_ON_ONCE(sp->role.direct || !vcpu->arch.mmu->sync_spte ||
			 (sp->role.word ^ root_role.word) & ~sync_role_ign.word))
		return -1;

Of course, the direct + match checks on the role effectively do the same, but I
would rather be explicit.

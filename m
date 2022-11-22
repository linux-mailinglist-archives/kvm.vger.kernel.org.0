Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7515663415B
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbiKVQXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbiKVQXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:23:07 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B608D1C909
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:23:06 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id q96-20020a17090a1b6900b00218b8f9035cso5594569pjq.5
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mndX8ySXqV/A7RweyaH+VqXePxP+UtgQs3fmb5mOoe4=;
        b=GpxBz3aJp8mXpuLCXQZRuQwVMtnYbPN06pv9TC0LpcGwt+HU21kH6PSQN0ikXhlksA
         KvWGGM3JzytzjwVd6dLDQWLds8yVCxLm8a4BLAHYNwmd0RWSASu2ks6ssvA2GYBpQgjw
         VelsnDgZaaLmhqxR4fHR7Q0AfyFGvmm9J0cUo8k+0W/KRyxVZXuokFqocve/L7hrsUZ3
         5CNWTgursamlmMc1397GMzv0ywMx86ESKyLChOenPs5x+TLV/n5tOAHCxHM3DG849daa
         21M3JBTeXZViKa/EcaJDlM2Bmzakyp9NAwK153xr6dufnXOro5EKJFVImF9gdX3tbYl0
         zolw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mndX8ySXqV/A7RweyaH+VqXePxP+UtgQs3fmb5mOoe4=;
        b=ahQiBzhTrdMBNsSw8Rtuo9zUcwUpgW3p5sV9Hobu+RwGu/UQFypfmhW4RfFLq/Vj6Z
         hKMj9EJE2BRqSMYZF91sFcHAAtlLLhnfHsQ0tJy2qDMgsjZKA/klnyZk1NdhyB5o6pMP
         9hrbGG+X1WEJFVLvsakV7OsHMHL6bz+QTmIfcLXIu/+H0bJ1yZ0QAgqCEGm4uDQ+mNuX
         ZJ9Bp8DI+TDaCabnqQW61HwNkohDJNQUTyYBTxW4u3J1nUIwfTwTdRK7Tu8Kq4+jaPBu
         yA4XFTWc20Yn102TxbgEoy4z3dYtoNtxFO1RINdIVEQUfwiQv+k28VQfiBBgzko1e2Pk
         epfQ==
X-Gm-Message-State: ANoB5pmWITex9VK6HNAQHykVCpDlHsAYGHjbYGPNZk05DUoyld1tAjc3
        zYv29HaeeEWkwBPL572MH2otpA==
X-Google-Smtp-Source: AA0mqf52USYIn91Dn1QSnOe5tT5ZXipauDDluMg26sfFbQQxjQ3G3Vq87yA5PMyNeYrqRuJz6jW7+g==
X-Received: by 2002:a17:903:4284:b0:189:f57:8f60 with SMTP id ju4-20020a170903428400b001890f578f60mr5130542plb.65.1669134185014;
        Tue, 22 Nov 2022 08:23:05 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c30-20020a056a00009e00b0056b3c863950sm10906019pfj.8.2022.11.22.08.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 08:23:04 -0800 (PST)
Date:   Tue, 22 Nov 2022 16:23:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Durrant, Paul" <pdurrant@amazon.co.uk>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mhal@rbox.co" <mhal@rbox.co>
Subject: Re: [PATCH 3/4] KVM: Update gfn_to_pfn_cache khva when it moves
 within the same page
Message-ID: <Y3z3ZVoXXGWusfyj@google.com>
References: <20221119094659.11868-1-dwmw2@infradead.org>
 <20221119094659.11868-3-dwmw2@infradead.org>
 <681cf1b4edf04563bba651efb854e77f@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <681cf1b4edf04563bba651efb854e77f@amazon.co.uk>
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

On Sat, Nov 19, 2022, Durrant, Paul wrote:
> > -----Original Message-----
> > From: David Woodhouse <dwmw2@infradead.org>
> > Sent: 19 November 2022 09:47
> > To: Paolo Bonzini <pbonzini@redhat.com>; Sean Christopherson
> > <seanjc@google.com>
> > Cc: kvm@vger.kernel.org; mhal@rbox.co
> > Subject: [EXTERNAL] [PATCH 3/4] KVM: Update gfn_to_pfn_cache khva when it
> > moves within the same page

Please use a mail client that doesn't include the header gunk in the reply.

> > CAUTION: This email originated from outside of the organization. Do not
> > click links or open attachments unless you can confirm the sender and know
> > the content is safe.
> > 
> > 
> > 
> > From: David Woodhouse <dwmw@amazon.co.uk>
> > 
> > In the case where a GPC is refreshed to a different location within the
> > same page, we didn't bother to update it. Mostly we don't need to, but
> > since the ->khva field also includes the offset within the page, that does
> > have to be updated.
> > 
> > Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> 
> Reviewed-by: <paul@xen.org>

Tags need your real name, not just your email address, i.e. this should be:

  Reviewed-by: Paul Durrant <paul@xen.org>

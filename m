Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F208A54D5C7
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 02:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350721AbiFPAFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 20:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350287AbiFPAE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 20:04:59 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4515537E
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 17:04:34 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id c196so39425pfb.1
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 17:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c92mwHl1qu3CL8Bv2XoRYTr+HyRnP5njRjoOPFBrr+g=;
        b=nLGAEpkdkdR0631/YVKfFtSpsTuAqetfRBovCIpgsLOLHXyUBlDMZ0EO9irIVcpoHD
         e7X93ZDNB88LBiBQR9Z2Vauz7n3oUN8sVBo+mk6mDSeQ29kCVpJjxwDBWOV6j89fOn0N
         MIo62i9eLUTImXDL936maskR2KqE0sN7jvVfPSHy8wIKcG3g3pJzw/h2V2shPZuF1ViT
         PPDQun6jy2GBzqo67SCFRhRlhlzA+nzMhJmb5Jw9y6gHmHHsnbW3Cs5E/YRy6ehc866B
         lefI1r0SdX+/Ueu/72TzVeGAohtKPyARSSUNWIJXOsrRSuZFy6ALkbD+C82KqHWY+Zru
         4qsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c92mwHl1qu3CL8Bv2XoRYTr+HyRnP5njRjoOPFBrr+g=;
        b=PEk46EC8keKTptYEOe+PxClc4khtMMjAvHjaspp3i8xCaWYWbf8J3GZBZAUfqsFrx+
         Xzl6iT+9V19A0QpvjrqNhmrQDNST5oYE3UZrpUR3dGTF1JOng0ehPggyfMZUdmGYZ0en
         BNGXVoQxCvoOTiWjIa7WfENlSzDiAjZPp4eDQlgBslHDXnPaqivxzuRMku4f7gEReZ2U
         0qnZtlJ9OEfxQBT5hTrys7zvB3yGfcZ+OKZE13gMJ+ysqSgdiBQuXvGVoFBWRdu5ZSAo
         SsvIaW8eWo8va8HAmchNKhU27pNjdlJ7rFk8pyxFaJi3eWejCYKw10YSWfkp8K9T5vvO
         S9Jg==
X-Gm-Message-State: AJIora8S3WXqL2Gt7xfZd14bIpsE0fQwH+9VGQD9FQnkV2xpNDY/pjFQ
        pvUnYwvjHOb4JVy0hUBRimzZng==
X-Google-Smtp-Source: AGRyM1uhiz1zq7+euq7iD4A7tSHoS5GGPykMWMAYny3MCTynFIw0cVV/Kt4RIZ+nESOJxi87nLTJeg==
X-Received: by 2002:a63:9043:0:b0:408:a759:2234 with SMTP id a64-20020a639043000000b00408a7592234mr1998816pge.304.1655337873496;
        Wed, 15 Jun 2022 17:04:33 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902d88500b0016762bb256csm180398plz.281.2022.06.15.17.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 17:04:33 -0700 (PDT)
Date:   Thu, 16 Jun 2022 00:04:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 4/8] x86: Improve set_mmu_range() to
 implement npt
Message-ID: <YqpzjMY+w5MZfb81@google.com>
References: <20220428070851.21985-1-manali.shukla@amd.com>
 <20220428070851.21985-5-manali.shukla@amd.com>
 <YqpyC1HmsFBSXedh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqpyC1HmsFBSXedh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 15, 2022, Sean Christopherson wrote:
> On Thu, Apr 28, 2022, Manali Shukla wrote:
> > +void setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len, bool nested_mmu)
> >  {
> >  	u64 max = (u64)len + (u64)start;
> >  	u64 phys = start;
> >  
> > -	while (phys + LARGE_PAGE_SIZE <= max) {
> > -		install_large_page(cr3, phys, (void *)(ulong)phys);
> > -		phys += LARGE_PAGE_SIZE;
> > -	}
> > -	install_pages(cr3, phys, max - phys, (void *)(ulong)phys);
> > +        if (nested_mmu == false) {
> > +                while (phys + LARGE_PAGE_SIZE <= max) {
> > +                        install_large_page(cr3, phys, (void *)(ulong)phys);
> > +		        phys += LARGE_PAGE_SIZE;
> > +	        }
> > +	        install_pages(cr3, phys, max - phys, (void *)(ulong)phys);
> > +        } else {
> > +                set_pte_opt_mask();
> > +                install_pages(cr3, phys, len, (void *)(ulong)phys);
> > +                reset_pte_opt_mask();
> > +        }
> 
> Why can't a nested_mmu use large pages?

Oh, duh, you're just preserving the existing functionality.

I dislike bool params, but I also don't see a better option at this time.  To make
it slightly less evil, add a wrapper so that the use and bool are closer together.
And then the callers don't need to be updated.

void __setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len, bool use_hugepages);

static inline void setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len)
{
	__setup_mmu_range(cr3, start, len, true);
}


And if you name it use_hugepages, then you can do:

void __setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len, bool nested_mmu)
{
        u64 orig_opt_mask = pte_opt_mask;
	u64 max = (u64)len + (u64)start;
	u64 phys = start;

	/* comment goes here. */
	pte_opt_mask |= PT_USER_MASK;

        if (use_hugepages) {
                while (phys + LARGE_PAGE_SIZE <= max) {
                        install_large_page(cr3, phys, (void *)(ulong)phys);
		        phys += LARGE_PAGE_SIZE;
	        }
	}
	install_pages(cr3, phys, max - phys, (void *)(ulong)phys);

	pte_opt_mask = orig_opt_mask;
}

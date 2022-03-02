Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580B94CADC6
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244683AbiCBSom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244671AbiCBSok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:44:40 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27ADBCA32D;
        Wed,  2 Mar 2022 10:43:57 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id h16-20020a4a6f10000000b00320507b9ccfso2933907ooc.7;
        Wed, 02 Mar 2022 10:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j+vTUnqa/aRGGzxIeIJpG4vQ+aqSIVjVhl8/XU2n+jM=;
        b=OexBrWql6KhyoHbRnx1JJYuKhZooJGTYyKVe9d05H5ttAdABxcVqk+FAhysK4OtxBQ
         BorE52DogDAk892/I8uPzm7ZB9MZ+4hcvfieKqkIQAh9P1fbfg4y9dDoR0c+ZdOuR3l6
         2YHEcUlUTNtIJj1x0Inplt63WqfK+Bqb5NdTAl8l8noyMnzolx3YhyjX0e5fcAUTeWka
         S4hlMQl9qfS31CjHvtDJzFbDk3kn6NaPQodr5m+EAT3YlxhE/dPURFbUCBkx58NOgVXU
         rdf/L//dY83bpmVw5UMaBtMYiS5qIu4Dxcq0nOqiAEatvQofbZsjtDxqUOZrcRzAwjxA
         N0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j+vTUnqa/aRGGzxIeIJpG4vQ+aqSIVjVhl8/XU2n+jM=;
        b=RWoU4YKfatB+YHNnEVtqDuSLG7ip1mvCR1rWm/WEInaPG1lM/hk/WnuYrqt8rpsEK2
         Qwp9jqtOmcBeqXb6CeH2hY58nTXg/gFaEd1DvGC5mVs9eTMdiD+HyBG99KWCS4Ma11Im
         3+1XdwXrVras9TqSM9J8L25PyjEDfR/fsD3a1CGv+uKV28obm1pvDXtVd8MvgGYCPn0n
         9cE7qMdelDQJeW2xxu61P0ZjxizgKuX71no+DtI0AdntVyEnKAfm2RIko0LWzlVUnZML
         p5iVZShLKLN06BgQygAHItH5zHeQ598rutY6kZCdUARCibTZN9J64Vu05WN+n0oTMb9G
         H9Ew==
X-Gm-Message-State: AOAM533zXK2OatK93BxQmSjqf2rWEXaHEIS7cSPvNZI+AB6eJOxTpi98
        XR8vzjGkBg67er294FNhBtbrd1Jhw+E=
X-Google-Smtp-Source: ABdhPJxiCFyZpaoI0/WSk3IJBfoGPt4Z1fSH5s8EhHar/UtvfabhTR7cBRrQfqDn+Jqe0iOOwX6eQw==
X-Received: by 2002:a05:6870:a919:b0:d5:7a09:1e88 with SMTP id eq25-20020a056870a91900b000d57a091e88mr948969oab.112.1646246636422;
        Wed, 02 Mar 2022 10:43:56 -0800 (PST)
Received: from localhost ([98.200.8.69])
        by smtp.gmail.com with ESMTPSA id fo25-20020a0568709a1900b000d441d5fdc5sm7846884oab.9.2022.03.02.10.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 10:43:55 -0800 (PST)
Date:   Wed, 2 Mar 2022 10:43:54 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Michael Mueller <mimu@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH v1 1/1] KVM: s390: Don't cast parameter in bit operations
Message-ID: <Yh+66v3OJZanfBLb@yury-laptop>
References: <20220223164420.45344-1-andriy.shevchenko@linux.intel.com>
 <20220224123620.57fd6c8b@p-imbrenda>
 <3640a910-60fe-0935-4dfc-55bb65a75ce5@linux.ibm.com>
 <Yh+Qw6Pb+Cd9JDNa@smile.fi.intel.com>
 <Yh+m65BSfQgaDFwi@yury-laptop>
 <Yh+qDhd6FL9nlQdD@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh+qDhd6FL9nlQdD@smile.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022 at 07:31:58PM +0200, Andy Shevchenko wrote:
> On Wed, Mar 02, 2022 at 09:18:35AM -0800, Yury Norov wrote:
> > On Wed, Mar 02, 2022 at 05:44:03PM +0200, Andy Shevchenko wrote:
> > > On Thu, Feb 24, 2022 at 01:10:34PM +0100, Michael Mueller wrote:
> > > > On 24.02.22 12:36, Claudio Imbrenda wrote:
> > > 
> > > ...
> > > 
> > > > we do that at several places
> > > 
> > > Thanks for pointing out.
> > > 
> > > > arch/s390/kernel/processor.c:	for_each_set_bit_inv(bit, (long
> > > > *)&stfle_fac_list, MAX_FACILITY_BIT)
> > > 
> > > This one requires a separate change, not related to this patch.
> > > 
> > > > arch/s390/kvm/interrupt.c:	set_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long
> > > > *) gisa);
> > > 
> > > This is done in the patch. Not sure how it appears in your list.
> > > 
> > > > arch/s390/kvm/kvm-s390.c:		set_bit_inv(vcpu->vcpu_id, (unsigned long *)
> > > > sca->mcn);
> > > > arch/s390/kvm/kvm-s390.c:		set_bit_inv(vcpu->vcpu_id, (unsigned long *)
> > > > &sca->mcn);
> > > 
> > > These two should be fixed in a separate change.
> > > 
> > > Also this kind of stuff:
> > > 
> > > 	bitmap_copy(kvm->arch.cpu_feat, (unsigned long *) data.feat,
> > > 	            KVM_S390_VM_CPU_FEAT_NR_BITS);
> > > 
> > > might require a new API like
> > > 
> > > bitmap_from_u64_array()
> > > bitmap_to_u64_array()
> > > 
> > > Yury?
> > 
> > If BE32 is still the case then yes.
> 
> The whole point is to get rid of the bad pattern, while it may still work
> in the particular case.

Then yes unconditionally. Is it already on table of s390 folks? If no,
I can do it myself.

We have bitmap_from_arr32 and bitmap_to_arr32, so for 64-bit versions,
we'd start from that.

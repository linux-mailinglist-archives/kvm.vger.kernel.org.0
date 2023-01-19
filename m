Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762376733AB
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 09:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjASI3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 03:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjASI3I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 03:29:08 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC75AC
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 00:29:06 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id v13so1881610eda.11
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 00:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=x5ck+uBW+we5mcml99JIlI5hbqOexLvffduO15vMLCQ=;
        b=JtUEKYA4ngIiCcO38C3pG5dWS8AmHuQYxbH7z4bS0gjTrWl2JjNzmgu+bHT1rhVvCF
         1AyQtvmN+FtmrNaWPPlJxZ1bL2eW7Oditr9V7+Te0BCwylH/bu1UdZdtD74u9sKME4pq
         4gLh+tfjkooAP7I3TeDdqGgUeUnakDAAJVoJn1lZJ0nt6ynYWYQ2hSzGBEW18rNJpTE7
         X/bTKUyOfdx/C86S3LXuUQzM7SIH2k3OgDl+54FiyHI4lRaVEg82PMf5IzorscxABa4G
         3rV6OMUb6N6Qq3ZkX/pp6a00uXYu/B094V6gztspTEq96rPZswMmsEwrXoIDCMXflQrs
         Yk6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x5ck+uBW+we5mcml99JIlI5hbqOexLvffduO15vMLCQ=;
        b=eTFMUwFaZGSlZ7Xi/ERUZ4l2ZUcg/p9r6QBtpeUdFL4NAL+UOO6kVv6Y4GRMongBCz
         dD6YiBRD2OGd+D2Ho9JvFIQywB78kAVA6H7qyT86K3Hhn6OHFgBsvD7KAps9OcIbVh4b
         i3WvCc9t9X55KnVdcnCTjwmc3XpChBsDY6pZQlYQR8qCkWYrVJ8DwtlRDvR98DxITahP
         qTJzcPTNVdnHDSfkDXDzvEGEwa8wSA2339ZZjROZs4AQhak+0haUx/kVJTRrJLMgmY5O
         ft4NxfhVt5t9sblew6kOHavhiEKJEaNHHwitRt6xuE++bTZ3pKA/TpbpF1vKUzTxFeCn
         tpew==
X-Gm-Message-State: AFqh2kodh4tqMVsCFKNQXMOgCT9JL3ZPazr4T90dcLczB8KjU9EkO7vf
        A2J2ZGAPWr6Wo/mgCwUbl4LD8wK6V7dy41KZ
X-Google-Smtp-Source: AMrXdXt37wqPfFZsW/BhY2ZBx33uOivJd/nYfcmjoJqMYW92j1bl/42mtZmEp65y22+4CKilHwwZSg==
X-Received: by 2002:a05:6402:b:b0:496:f517:d30d with SMTP id d11-20020a056402000b00b00496f517d30dmr10408911edu.38.1674116945288;
        Thu, 19 Jan 2023 00:29:05 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id a3-20020aa7cf03000000b0049019b48373sm15294210edy.85.2023.01.19.00.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 00:29:04 -0800 (PST)
Date:   Thu, 19 Jan 2023 09:29:03 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Conor Dooley <conor@kernel.org>
Cc:     Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v3 05/13] riscv: cpufeature: extend
 riscv_cpufeature_patch_func to all ISA extensions
Message-ID: <20230119082903.yk3uslfrjtxzassi@orel>
References: <20230111171027.2392-1-jszhang@kernel.org>
 <20230111171027.2392-6-jszhang@kernel.org>
 <2398293.3Lj2Plt8kZ@diego>
 <20230112092136.f2g43hrhmrqouy4y@orel>
 <Y8F2YxMHUt+djhX4@wendy>
 <Y8MRZQENua+wi34T@spud>
 <Y8hqptFcUgjhns4F@spud>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y8hqptFcUgjhns4F@spud>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 18, 2023 at 09:54:46PM +0000, Conor Dooley wrote:
> Hey!
> 
> I guess here is the right place to follow up on all of this stuff...
> 
> On Sat, Jan 14, 2023 at 08:32:37PM +0000, Conor Dooley wrote:
> > On Fri, Jan 13, 2023 at 03:18:59PM +0000, Conor Dooley wrote:
> > > On Thu, Jan 12, 2023 at 10:21:36AM +0100, Andrew Jones wrote:
> > > > On Thu, Jan 12, 2023 at 12:29:57AM +0100, Heiko Stübner wrote:
> > > > > Am Mittwoch, 11. Januar 2023, 18:10:19 CET schrieb Jisheng Zhang:
> > > > > > riscv_cpufeature_patch_func() currently only scans a limited set of
> > > > > > cpufeatures, explicitly defined with macros. Extend it to probe for all
> > > > > > ISA extensions.
> > > > > > 
> > > > > > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > > > > > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > > > > > Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> > > > > > ---
> > > > > >  arch/riscv/include/asm/errata_list.h |  9 ++--
> > > > > >  arch/riscv/kernel/cpufeature.c       | 63 ++++------------------------
> > > > > >  2 files changed, 11 insertions(+), 61 deletions(-)
> > > > > 
> > > > > hmmm ... I do see a somewhat big caveat for this.
> > > > > and would like to take back my Reviewed-by for now
> > > > > 
> > > > > 
> > > > > With this change we would limit the patchable cpufeatures to actual
> > > > > riscv extensions. But cpufeatures can also be soft features like
> > > > > how performant the core handles unaligned accesses.
> > > > 
> > > > I agree that this needs to be addressed and Jisheng also raised this
> > > > yesterday here [*]. It seems we need the concept of cpufeatures, which
> > > > may be extensions or non-extensions.
> > > > 
> > > > [*] https://lore.kernel.org/all/Y77xyNPNqnFQUqAx@xhacker/
> > > > 
> > > > > See Palmer's series [0].
> > > > > 
> > > > > 
> > > > > Also this essentially codifies that each ALTERNATIVE can only ever
> > > > > be attached to exactly one extension.
> > > > > 
> > > > > But contrary to vendor-errata, it is very likely that we will need
> > > > > combinations of different extensions for some alternatives in the future.
> > > > 
> > > > One possible approach may be to combine extensions/non-extensions at boot
> > > > time into pseudo-cpufeatures. Then, alternatives can continue attaching to
> > > > a single "feature". (I'm not saying that's a better approach than the
> > > > bitmap, I'm just suggesting it as something else to consider.)
> > > 
> > > 
> > > > >         ALTERNATIVE_2("nop",
> > > > >                       "j strcmp_zbb_unaligned", 0, CPUFEATURE_ZBB | CPUFEATURE_FAST_UNALIGNED, 0, CONFIG_RISCV_ISA_ZBB,
> > > > >                       "j variant_zbb", 0, CPUFEATURE_ZBB, CPUFEATURE_FAST_UNALIGNED, CONFIG_RISCV_ISA_ZBB)
> > > > > 
> > > > > [the additional field there models a "not" component]
> > > 
> > > Since we're discussing theoretical implementations, and it's a little hard
> > > to picture all that they entail in my head, I might be making a fool of
> > > myself here with assumptions...
> > > 
> > > Heiko's suggestion sounded along the lines of: keep probing individual
> > > "features" as we are now. Features in this case being the presence of
> > > the extension or non-extension capability. And then in the alternative,
> > > make all of the decisions about which to apply.
> > > 
> > > Drew's suggestion would have significantly more defined CPUFEATURE_FOOs,
> > > but would offload the decision making about which extensions or non-
> > > extension capabilities constitute a feature to regular old cpufeature
> > > code. However, the order of precedence would remain in the alt macro, as
> > > it does now.
> > > 
> > > I think I am just a wee bit biased, but adding the complexity somewhere
> > > other than alternative macros seems a wise choice, especially as we are
> > > likely to find that complexity increases over time?
> > > 
> > > The other thing that came to mind, and maybe this is just looking for
> > > holes where they don't exist (or are not worth addressing), is that
> > > order of precedence.
> > > I can imagine that, in some cases, the order of precedence is not a
> > > constant per psuedo-cpufeature, but determined by implementation of
> > > the capabilities that comprise it?
> > 
> > Having spent longer than I maybe should've looking at your patches
> > Heiko, given it's a Saturday evening, the precedence stuff is still
> > sticking out to me..
> > 
> > For Zbb & fast unaligned, the order may be non-controversial, but in
> > the general case I don't see how it can be true that the order of
> > precedence for variants is a constant.
> > 
> > Creating pseudo cpufeatures as Drew suggested does seem like a way to
> > extract complexity from the alternatives themselves (which I think is a
> > good thing) but at the expense of eating up cpu_req_feature bits...
> > By itself, it doesn't help with precedence, but it may better allow us
> > to deal with some of the precedence in cpufeature.c, since the
> > alternative would operate based on the pseudo cpufeature rather than on
> > the individual capabilities that the pseudo cpufeature depends on.
> > 
> > I tried to come up with a suggestion for what to do about precedence,
> > but everything I thought up felt a bit horrific tbh.
> > The thing that fits the current model best is just allowing cpu vendors
> > to add, yet more, "errata" that pick the variant that works best for
> > their implementation... Although I'd be worried about ballooning some of
> > these ALT_FOO macros out to a massive degree with that sort of approach.
> > 
> > > If my assumption/understanding holds, moving decision making out of the
> > > alternative seems like it would better provision for scenarios like
> > > that? I dunno, maybe that is whatever the corollary of "premature
> > > optimisation" is for this discussion.
> > > 
> > > That's my unsolicited € 0.02, hopefully I wasn't off-base with the
> > > assumptions I made.
> > 
> > The order in which an alternative is added to the macro does matter,
> > right? At least, that's how I thought it worked and hope I've not had
> > an incorrect interpretation there all along... I wasn't until I started
> > reading your patch and couldn't understand why you had a construct that
> > looked like
> > 
> > if (zbb && !fast_unaligned)
> > ...
> > else if (zbb && fast_unaligned)
> > ...
> > 
> > rather than just inverting the order and dropping the !fast_unaligned
> > that I realised I might have a gap in my understanding after all..
> > 
> > > Heiko, I figure you've got some sort of WIP stuff for this anyway since
> > > you're interested in the fast unaligned? How close are you to posting any
> > > of that?
> > > 
> > > While I think of it, w.r.t. extension versus (pseudo)cpufeature etc
> > > naming, it may make sense to call the functions that this series adds
> > > in patch 6 has_cpufeature_{un,}likely(), no matter what decision gets
> > > made here?
> > > IMO using cpufeature seems to make more sense for a general use API that
> > > may be used later on for the likes of unaligned access, even if
> > > initially it is not used for anything other than extensions. 
> 
> Today at [1] we talked a bit about the various bits going on here.
> I'll attempt to summarise what I remember, but I meant to do this
> several hours ago and am likely to make a hames of it.
> 
> For Zbb/unaligned stuff, the sentiment was along the lines of there
> needing to be a performance benefit to justify the inclusion.
> Some of us have HW that is (allegedly) capable of Zbb, and, if that's the
> case, will give it a go.
> I think it was similar for unaligned, since there is nothing yet that
> supports this behaviour, we should wait until a benefit is demonstrable.
> 
> On the subject of grouping extension/non-extension capabilities into a
> single cpufeature, Palmer mentioned that GCC does something similar,
> for the likes of the Ventana vendor extensions, that are unlikely to be
> present in isolation.
> Those are (or were?) probed as a group of extensions rather than
> individually.
> I think it was said it'd make sense for us to unify extensions that will
> only ever appear together single psuedo cpufeature too.
> 
> For the bitfield approach versus creating pseudo cpufeatures discussion
> & how to deal with that in alternatives etc, I'm a bit less sure what the
> outcome was.
> IIRC, nothing concrete was said about either approach, but maybe it was
> implied that we should do as GCC does, only grouping things that won't
> ever been seen apart.
> Figuring that out seems to have been punted down the road, as the
> inclusion of our only current example of this (Zbb + unaligned) is
> dependant on hardware showing up that actually benefits from it.
> 
> The plan then seemed to be press ahead with this series & test the
> benefits of the Zbb str* functions in Zbb capable hardware before making
> a decision there.
> 
> Hopefully I wasn't too far off with that summary...

This matches my recollection. Thanks for the summary, Conor.

drew

> 
> Thanks,
> Conor.
> 
> 1 - https://lore.kernel.org/linux-riscv/mhng-775d4068-6c1e-48a4-a1dc-b4a76ff26bb3@palmer-ri-x1c9a/



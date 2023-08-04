Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FA9770C17
	for <lists+kvm@lfdr.de>; Sat,  5 Aug 2023 00:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjHDWpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 18:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjHDWpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 18:45:38 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2217446B3
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 15:45:37 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-584139b6b03so27818087b3.3
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 15:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691189136; x=1691793936;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qzzGQVsyCKQuIHhNuvYJJsNQNLnIEOy51Xxy7T0276E=;
        b=vyT9iRvBkAPxrhUM4loOuXv0ZWxpARTSozCHpx4ia9Cea9tMKrN/2RonnEmIi/91Y6
         D9/kIxa3brvZlRc6QGKk01Hyt0jEboWVl3Z8oGFhLtizQUeXWjYBQlLJ3hEkbES8ojIp
         xRHERUnWaRuKMo9qbYUtw33JY4PImnq6niFxGhMqp8fDR7KFDwcJ/mK4TqIKH6HSmO9R
         Cw2H5HztJsHwRfX7RoC4cz33QJ8+8AwE8bdX3ip787drt5sStO7eeTcFQcC2vu6O5EC1
         Jrv3s4q/GFzOUfGTyRixDp4N8PQ6wNQ7wlh9jGLouPYEjbTRIjnzGQFCnlolt9BIg96Q
         MmWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691189136; x=1691793936;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qzzGQVsyCKQuIHhNuvYJJsNQNLnIEOy51Xxy7T0276E=;
        b=RFTKShvWlvsKaai4dLYpuE7ZwPSkesaqbg32E6GzwlTLfuQgHaYqjJ8LQSWpToiJRx
         cqnhbwzzZTsoWWfWsNZY5WBz3okE8snenW5eesRb7Te2GQrq/96Xom7m3fJCovvr12fE
         Pvu+cQQwAKtXAOE37zk2dT/PxXF/xexYcD+61DvhoJo9q1KgMko+n0mI0qsSvOAUGemv
         dWDu6p1b2DozrRDNoI9lMqWH9zEkt8THJUH8GDvF9TDzCktT/Fk5+HW6QjTSpOvJQ+CY
         AZY63YCu/k/kCXhz3UpCRGI0Kvlow6HEcoAmGaVXNq3cD9VRr+p/vh+nlf4iqcILERj1
         Xu0w==
X-Gm-Message-State: AOJu0YybbP6ZHqovZOpMwuvr8MJ0il8ewb3hP3KQoujMNPpyRX0ugU6B
        I8nlnF5p6Gh2b7D5sGZ1vByj9Ebkzuw=
X-Google-Smtp-Source: AGHT+IEWfwtnQQ08PS920/iWYAxu1snSlSkt7kEi/UPqLCtV3oacTE1j6eL7G0tfMsosYlmzaiDwjq+gcnQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6b4a:0:b0:cb6:6c22:d0f8 with SMTP id
 o10-20020a256b4a000000b00cb66c22d0f8mr16070ybm.4.1691189136427; Fri, 04 Aug
 2023 15:45:36 -0700 (PDT)
Date:   Fri, 4 Aug 2023 15:45:34 -0700
In-Reply-To: <CAD=HUj41PAKC0x+c3zWAr-aCm59K7hs2zRh1uWs9778_Mai4UA@mail.gmail.com>
Mime-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-6-stevensd@google.com>
 <20230705101800.ut4c6topn6ylwczs@linux.intel.com> <CAD=HUj41PAKC0x+c3zWAr-aCm59K7hs2zRh1uWs9778_Mai4UA@mail.gmail.com>
Message-ID: <ZM1/jhJXu8OGUrkb@google.com>
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to __kvm_follow_pfn
From:   Sean Christopherson <seanjc@google.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 06, 2023, David Stevens wrote:
> On Wed, Jul 5, 2023 at 7:17=E2=80=AFPM Yu Zhang <yu.c.zhang@linux.intel.c=
om> wrote:
> >
> > On Tue, Jul 04, 2023 at 04:50:50PM +0900, David Stevens wrote:
> > > From: David Stevens <stevensd@chromium.org>
> > >
> > > Stop passing FOLL_GET to __kvm_follow_pfn. This allows the host to ma=
p
> > > memory into the guest that is backed by un-refcounted struct pages - =
for
> > > example, higher order non-compound pages allocated by the amdgpu driv=
er
> > > via ttm_pool_alloc_page.
> >
> > I guess you mean the tail pages of the higher order non-compound pages?
> > And as to the head page, it is said to be set to one coincidentally[*],
> > and shall not be considered as refcounted.  IIUC, refcount of this head
> > page will be increased and decreased soon in hva_to_pfn_remapped(), so
> > this may not be a problem(?). But treating this head page differently,
> > as a refcounted one(e.g., to set the A/D flags), is weired.
> >
> > Or maybe I missed some context, e.g., can the head page be allocted to
> > guest at all?
>=20
> Yes, this is to allow mapping the tail pages of higher order
> non-compound pages - I should have been more precise in my wording.
> The head pages can already be mapped into the guest.

Recording for posterity (or to make an incorrect statment and get corrected=
),
because I recently had a conversation about the head page not actually bein=
g
refcounted.  (I can't remember with whom I had the conversation, but I'm pr=
etty
sure it wasn't an imaginary friend).

Even though whatever allocates the page doesn't explicit refcount the head =
page,
__free_pages() will still do the right thing and (a) keep the head page aro=
und
until its last reference is put.  And my understanding is that even though =
it's
a "head" page, it's not a PG_head page, i.e. not a compound page and so is =
treated
as an order-0 page when KVM invoke put_page().

void __free_pages(struct page *page, unsigned int order)
{
	/* get PageHead before we drop reference */
	int head =3D PageHead(page);

	if (put_page_testzero(page))  <=3D=3D=3D will evaluate false if KVM holds =
a ref
		free_the_page(page, order);
	else if (!head)  <=3D=3D=3D will be false for non-compound pages
		while (order-- > 0)
			free_the_page(page + (1 << order), order);
}
EXPORT_SYMBOL(__free_pages);

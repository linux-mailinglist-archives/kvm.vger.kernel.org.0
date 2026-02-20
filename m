Return-Path: <kvm+bounces-71423-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kK8oGgDEmGl/LwMAu9opvQ
	(envelope-from <kvm+bounces-71423-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 21:28:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DEA9216AA38
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 21:28:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B51C43013B7D
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 20:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 406923019BE;
	Fri, 20 Feb 2026 20:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LWYT9a3X";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="uCj/7ikI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1E31DFD8B
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 20:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771619320; cv=pass; b=fIpXO7NhWosPhwxC1A98VEQ2B2YcVh+OGsaC1zd47fO0zNRW78knPGsR8nY6wKm1cIZGZXSjn48PBhluR4xvCR//61PT4ugLoKjHGf2YNqi+HumoYfayBQTWh9jWXc9woFbrb4FK9WvzM2BaMHx8n7617nsfzqFuhJ1CRIxbkI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771619320; c=relaxed/simple;
	bh=XfpwM74Kc0+xuMV42TYAnaHdmYHCXjxKWzKLjOF3tMc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=abH3GLVjpf+SmP7UlMb/iGgWItcUb3R2UrwWk4UT2A9a5E34Ifq4Sj++jD39lA/AsygciK2UAqVuyjkYNZxeru7514QCpjp4vtMwyYrLcWWAGQ824dmcD9Hb9oo2RgwnK4hRQj01TwXNPvPLXvJY+C/j/D5IZU4Nm1l0mK9TNEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LWYT9a3X; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=uCj/7ikI; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771619317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/48DeeAFSXbOHRgzgfj1Dvf3GpZcG6f2yHrcvSYykPE=;
	b=LWYT9a3Xx1WzIxREbda4DyXryTJjDoTHiA1ldFTu0lyyHzlfJNKSzTPMrdA4DMs6XodE8e
	LuQH+imIfL92UTxGLBi0mr6Q9/BSNHZ0gdyukJF7g8gqE5+4Eaqm86LA17307cwZf4M1UN
	i+PsCuq6rg8wt4jsNz/yQUNMyLlfbUw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-IT0Q-BsONuClNr8awElkPA-1; Fri, 20 Feb 2026 15:28:36 -0500
X-MC-Unique: IT0Q-BsONuClNr8awElkPA-1
X-Mimecast-MFC-AGG-ID: IT0Q-BsONuClNr8awElkPA_1771619315
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35449510446so2694419a91.0
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 12:28:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771619315; cv=none;
        d=google.com; s=arc-20240605;
        b=XCHw5nyVyXPngIdZ7DmjpQJgKb/y3vu3mZHmxZIKyDwPV/fLI+vhGVIIY2KJSSX5sA
         +kRRoPAize4ybSfcq+PxSML42GlnZAG8LNF4B6Ry9X8a6d+HHLDU1CTsdvkhSLcNfqRN
         OEFSHmJy0W29B2zCiGJ1ETtVzIENggSJqyroDi5NLt2f2qU7+aHUNK2qJX8/9/dl1vWi
         fbSHAAqt8vKbIgdNvWC7gPaJ6Tqj9rzHALl62Itkzmtl7REFOx/eJumZjmHc9ADMZ6Lz
         fSHERmKKprWz5J5bAeCmxdntCjNGSbdrWXpuOEu4bj2wndzgMVJ/Q6GBhsWAeNhl09KQ
         W01Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/48DeeAFSXbOHRgzgfj1Dvf3GpZcG6f2yHrcvSYykPE=;
        fh=/opp+sh2YUyIwCpHdh4BQckGPRG/cTQdHDdihdfhzI4=;
        b=eHrZMMLX/vYBnfUWe6spxK0pfIKQ1i7/0oH97tSQQwJDZGdqeewYLqkQ6xdSYFQv7N
         hASLheLpTMQdIz58nrQD/uQkJxgFapYo+ziOwNZbaLeXV3g/S1Sg/voAGi5TSojOX7CR
         dDgZ/5dnjsPdQJYkA+RY3TJboHZRWLWQ0VgeGHjOtnj/F35w40m1IptG1rawN2CSSsrg
         VemTCCXkgnN5wf6ekeOx0wixjzkpy47W1YLv2HtQWFONNTqdv9uh/Wk7MdBYOMqH62Cj
         LdiF7kzhwKbgcRxslXZYSh3jqCB8bqR+N+FbyJHRL1lv4Dsx8bQlMe+HwQUbHH7mhNke
         MIbA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771619315; x=1772224115; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/48DeeAFSXbOHRgzgfj1Dvf3GpZcG6f2yHrcvSYykPE=;
        b=uCj/7ikIa7ZxAhsX4MHi4qdX8VCutqsd/tbHsP7L5Mz9QNyXM7/fqT1lwioUouAeUf
         6NXEE7fzTg7iKEo2Ah4sduHmxCCpvbbIbxIR2FQvQSEpPrhmMrshh23w5/I2YNewl/FG
         B3gQ757ZeEiMmBXLQjL4Q84DXXLrRtbi2RWzF6RhWqHJH9HEyoti7rTrXtLRob5wXVhG
         dDhbTYVv9zm7GK64YXA5MaS4RGUgHVjCIX+ftTGmucIFr3aYy0WT4cgyBEqLUImdTgjy
         lKq7l2AElh+NNvzA53/eCAk4fyuK1CyruJcO6ILiR6R+u3Vf3tXbT8RbD7IirABsbN1d
         fCiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771619315; x=1772224115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/48DeeAFSXbOHRgzgfj1Dvf3GpZcG6f2yHrcvSYykPE=;
        b=liuH9lgTVQKuc8/dgAPb/sR1lfx5y0N1E927iPqlfgBR5XA1cwfsNpuQejacSocx+5
         61eb0Rim5Oo9eBr0ZJj6SITImCs/lOcue02gC5F9Sxl9/7caiU9SViViEu8iTwO5Er5b
         5c8iSoC1DsH2WbLHljO5TPxPTJDWx9EoZyvOGMVwoyDBjdmlX1nE+iJ1Qm9scw0wetsj
         s5YXfjdcsefKSPdspju/QmVns+CJMLHiyAJ53QIAT8geNeSR5GJ2k63GszcH0i6Ny/s4
         pVOt6FIWJFjPIr5OGIxTDCXMnG4B4ZY+nqZoUvD4dRBstUFAazIEm6anG3ih+PhAr5rX
         N1cQ==
X-Forwarded-Encrypted: i=1; AJvYcCXq6DQAE3QzI69qtwyhxQaG80jhrh0NEY58+b24D00n8xsyOiK3WiSLDXh56b9nbVOf4p4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKyfpb/m1Rt3O0j1nk7xfBlksR0jQ4AUr2/NmuO6qbVsc70VAJ
	ahE8DjU8V8T/LalETaRqtvurHNhA2MuHmj2NgGRkk2txcm7LYsfCw96PBW/zW5I5bNgLaV9vUpV
	ClDcmzotgzGHYeQaYP9ZbtHVUPPJTyZbLsUpStXuRo7ze9cZSwYtov0k0nK4TVK4vZksD867lEp
	dzAXCwPb8pkTKC1TiwnrttSK9D9G6o
X-Gm-Gg: AZuq6aKWQjwQDbxnr0gmKszd41oc6dvL2y7yXlOedfWTWWZ5crr6pj4O1FU3unN962k
	1GL4O1/cfJdUpMd8cXttAgRhWFMe69sq2DV2/gWYMANIxEpIrYtRlrpZoj+i8wyD5EceFC24YDc
	Fjk5oAuPrIA+5wCy/ji01uL05g/CN/oLpFJDXSiTYV4Nl6FLfK4afr2gIF5l77r6n18e2MVHpAp
	pihj/9wiSzmL34T9jYkMngblo6GWJl34w4i5A==
X-Received: by 2002:a17:90b:562d:b0:356:2872:9c50 with SMTP id 98e67ed59e1d1-358ae8eaed3mr616537a91.35.1771619315063;
        Fri, 20 Feb 2026 12:28:35 -0800 (PST)
X-Received: by 2002:a17:90b:562d:b0:356:2872:9c50 with SMTP id
 98e67ed59e1d1-358ae8eaed3mr616521a91.35.1771619314667; Fri, 20 Feb 2026
 12:28:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260204100708.724800-1-marcandre.lureau@redhat.com>
 <20260204100708.724800-7-marcandre.lureau@redhat.com> <aZdnDrs9ivLctEIj@x1.local>
In-Reply-To: <aZdnDrs9ivLctEIj@x1.local>
From: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>
Date: Fri, 20 Feb 2026 21:28:23 +0100
X-Gm-Features: AaiRm50yX9GlRKPEH4YFffQtdOOsyPXPDbVGDGEckzbk5UhrHfiBW2nsykpY7jA
Message-ID: <CAMxuvax5uYVr0V3qKFV3t63BLkdqJco5thx23EKggH_dbKsAdQ@mail.gmail.com>
Subject: Re: [PATCH 06/10] system/memory: split RamDiscardManager into source
 and manager
To: Peter Xu <peterx@redhat.com>
Cc: qemu-devel@nongnu.org, =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, 
	kvm@vger.kernel.org, Alex Williamson <alex@shazbot.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ben Chaney <bchaney@akamai.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Fabiano Rosas <farosas@suse.de>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Mark Kanda <mark.kanda@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71423-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[marcandre.lureau@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DEA9216AA38
X-Rspamd-Action: no action

Hi

On Thu, Feb 19, 2026 at 8:40=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> On Wed, Feb 04, 2026 at 02:07:02PM +0400, marcandre.lureau@redhat.com wro=
te:
> > From: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
> >
> > Refactor the RamDiscardManager interface into two distinct components:
> > - RamDiscardSource: An interface that state providers (virtio-mem,
> >   RamBlockAttributes) implement to provide discard state information
> >   (granularity, populated/discarded ranges, replay callbacks).
> > - RamDiscardManager: A concrete QOM object that wraps a source, owns
> >   the listener list, and handles listener registration/unregistration
> >   and notifications.
> >
> > This separation moves the listener management logic from individual
> > source implementations into the central RamDiscardManager, reducing
> > code duplication between virtio-mem and RamBlockAttributes.
> >
> > The change prepares for future work where a RamDiscardManager could
> > aggregate multiple sources.
>
> The split of sources v.s. manager makes sense to me.
>
> I didn't follow the whole history of how the discard manager evolved, but
> IIUC it was called "discard manager" only because initially we were prett=
y
> much focused on the DONTNEED side of things so that when things got dropp=
ed
> we need to notify.
>
> However IIUC the current status quo of the discard manager covers both
> sides (population and discards).  It maintains what ranges of memory is
> available in general for consumption by listeners.
>
> For that, I wonder if during this major refactoring we should think about
> renaming this slightly misleading name.  Considering that the major
> difference of such special MR (either managed by virtio-mem or ramattr) i=
s
> about its "sparseness": say, not all of the memory is used but only a
> portion of it to be used in a somehow sparsed fashion, maybe
> SparseRamSources / SparseRamManager?  Another option I thought about is
> DynamicRam*.
>
> No strong feelings on the namings.  But raising this up in case you also
> think it might be a good idea.

That makes sense, it can be done later though, it's not blocking imho

>
> [...]
>
> > @@ -699,50 +682,60 @@ struct RamDiscardManagerClass {
> >       * @replay_discarded:
> >       *
> >       * Call the #ReplayRamDiscardState callback for all discarded part=
s within
> > -     * the #MemoryRegionSection via the #RamDiscardManager.
> > +     * the #MemoryRegionSection via the #RamDiscardSource.
> >       *
> > -     * @rdm: the #RamDiscardManager
> > +     * @rds: the #RamDiscardSource
> >       * @section: the #MemoryRegionSection
> >       * @replay_fn: the #ReplayRamDiscardState callback
> >       * @opaque: pointer to forward to the callback
> >       *
> >       * Returns 0 on success, or a negative error if any notification f=
ailed.
> >       */
> > -    int (*replay_discarded)(const RamDiscardManager *rdm,
> > +    int (*replay_discarded)(const RamDiscardSource *rds,
> >                              MemoryRegionSection *section,
> >                              ReplayRamDiscardState replay_fn, void *opa=
que);
>
> A major question I have here is how we should process replay_populated()
> and replay_discarded() when split the class.
>
> I had a gut feeling that this should not belong to the *Source object,
> instead it might be more suitable for the manager?
>
> I read into some later patches and I fully agree with your definition of
> aggregations when there're multiple sources, which mentioned in the commi=
t
> messsages later of this part:
>
>     The aggregation uses:
>     - Populated: ALL sources populated
>     - Discarded: ANY source discarded
>
> IOW, a piece of mem that is "private" in terms of ram attr manager, but
> "populated" in terms of virtio-mem, should be treated as discarded indeed=
.
>
> However I also saw that in some follow up patches the series did a trick =
to
> fetch the first Source then invoke the replay hook on the first source:
>
> int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
>                                          const MemoryRegionSection *secti=
on,
>                                          ReplayRamDiscardState replay_fn,
>                                          void *opaque)
> {
>     RamDiscardSourceEntry *first;
>     ReplayCtx ctx;
>
>     first =3D QLIST_FIRST(&rdm->source_list);
>     if (!first) {
>         return replay_fn(section, opaque);
>     }
>
>     ctx.rdm =3D rdm;
>     ctx.replay_fn =3D replay_fn;
>     ctx.user_opaque =3D opaque;
>
>     return ram_discard_source_replay_populated(first->rds, section,
>                                                aggregated_replay_populate=
d_cb,
>                                                &ctx);
> }
>
> It seems to me that aggregated_replay_populated_cb() will indeed still do
> the proper aggregations, however if we could move the replay functions in=
to
> the manager (or do we need it to be a hook at all?  Perhaps it will just =
be
> an API of the manager?), then we don't need this trick of fetching the 1s=
t
> source, instead the manager should do the math of "AND all the sources on
> reported populated info" then invoke the listener handlers.  Maybe that'l=
l
> be cleaner from the high level.
>
> What do you think?


Do you mean that we could drop replay_populated/replay_discarded from
the source? I think we could. replay_by_populated_state() already
handles the aggregation logic by using is_populated() alone. There
isn't much gain in the above implementation narrowing the iteration
from the first source replay.

thanks for the review



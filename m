Return-Path: <kvm+bounces-70166-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8FMGBiIVg2nihQMAu9opvQ
	(envelope-from <kvm+bounces-70166-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 10:45:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3529FE4041
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 10:45:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3C777300F1DA
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 09:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41F683B5311;
	Wed,  4 Feb 2026 09:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V8eS95Ri"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0E03A961B
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 09:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770198264; cv=none; b=h3k25WUp9jH/9C6wj9itdq45LWBZv3FHJHEqlAXEgylQLAAJNp4dTgokhhaukKNQlBF1nJ+JI0JIn2fqXnvkT+KIm83Eto5x7VpsRufT/CAz55hkW4+3br+PfBb+qyfch15ojql8BVpvluRaSuPy/YU+kuX8P/wvAqPuL7sdK2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770198264; c=relaxed/simple;
	bh=mXP3Wyu852v5v7KgCABfVQU/l+P+14CQSHOMbAkxIvo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SGmu1olMlmpQZxJ9xg2iaZLF3/BU0APRyXHuVgSnCSbz5MZe3JxMluBOFK+3BjihJsy/JsnXUatQmNo7VbYx3zovd9rTwgFwDyvBhWaRZy+xl/fY/HjQizY4Svvpc599J+WslGV2Nxh+z38+KAEr/goJP5qQX8Ktoh+5bZqlV7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V8eS95Ri; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770198263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rvk6f0QHfNg2ko/MR8M57vqIwTfpRqvJe/Y3E+jRsQY=;
	b=V8eS95RiX1DOiRIz6RUPeqPMuSXPLDYt1ZyPto/xqGnd4howeN43f/RDTbnrUSzogs63UE
	BPIsZlrGWDUP+l9Xz9Z1wvHv4uryqpFDwIh+wlAjDrFPp8fj1gHVey2O8IWLWT9z4iuYA6
	Gvd/UNFMOKqZ2GuwVtcmXVdvEX2EU3g=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-38-mu0aNqHCOsK6Mv6-ioL1Qw-1; Wed,
 04 Feb 2026 04:44:20 -0500
X-MC-Unique: mu0aNqHCOsK6Mv6-ioL1Qw-1
X-Mimecast-MFC-AGG-ID: mu0aNqHCOsK6Mv6-ioL1Qw_1770198258
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C5CE18003F5;
	Wed,  4 Feb 2026 09:44:18 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.22])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91CD718003F5;
	Wed,  4 Feb 2026 09:44:17 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 299E321E692D; Wed, 04 Feb 2026 10:44:15 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dave@treblig.org>,  Fabiano Rosas
 <farosas@suse.de>,  =?utf-8?Q?Marc-Andr=C3=A9?= Lureau
 <marcandre.lureau@redhat.com>,
  Stefan Hajnoczi <stefanha@gmail.com>,  qemu-devel
 <qemu-devel@nongnu.org>,  kvm <kvm@vger.kernel.org>,  Helge Deller
 <deller@gmx.de>,  Oliver Steffen <osteffen@redhat.com>,  Stefano
 Garzarella <sgarzare@redhat.com>,  Matias Ezequiel Vara Larsen
 <mvaralar@redhat.com>,  Kevin Wolf <kwolf@redhat.com>,  German Maglione
 <gmaglione@redhat.com>,  Hanna Reitz <hreitz@redhat.com>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,
  Thomas Huth <thuth@redhat.com>,  Mark Cave-Ayland
 <mark.cave-ayland@ilande.co.uk>,  Alex Bennee <alex.bennee@linaro.org>,
  Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: Re: Modern HMP
In-Reply-To: <aYMMRuWGYe96rpZZ@redhat.com> ("Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9=22's?= message of
	"Wed, 4 Feb 2026 09:07:18 +0000")
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
	<CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
	<871pjigf6z.fsf_-_@pond.sub.org> <aXH1ECZ1Nchui9ED@redhat.com>
	<87ikctg8a8.fsf@pond.sub.org> <aXIWLi656H8VbrPE@redhat.com>
	<87ikctk5ss.fsf@suse.de> <aXJJkd8g0AGZ3EVv@redhat.com>
	<aX-boauFX2Ju7x8Z@gallifrey> <875x8d0w32.fsf@pond.sub.org>
	<aYMMRuWGYe96rpZZ@redhat.com>
Date: Wed, 04 Feb 2026 10:44:15 +0100
Message-ID: <87ldh8zvv4.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70166-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	FREEMAIL_CC(0.00)[treblig.org,suse.de,redhat.com,gmail.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk];
	DBL_BLOCKED_OPENRESOLVER(0.00)[treblig.org:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,pond.sub.org:mid];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[armbru@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[20];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 3529FE4041
X-Rspamd-Action: no action

Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:

> On Wed, Feb 04, 2026 at 09:08:49AM +0100, Markus Armbruster wrote:
>> "Dr. David Alan Gilbert" <dave@treblig.org> writes:
>>=20
>> > * Daniel P. Berrang=C3=A9 (berrange@redhat.com) wrote:
>> >> On Thu, Jan 22, 2026 at 12:47:47PM -0300, Fabiano Rosas wrote:
>> >> > One question I have is what exactly gets (eventually) removed from =
QEMU
>> >> > and what benefits we expect from it. Is it the entire "manual"
>> >> > interaction that's undesirable? Or just that to maintain HMP there =
is a
>> >> > certain amount of duplication? Or even the less-than-perfect
>> >> > readline/completion aspects?
>> >>=20
>> >> Over time we've been gradually separating our human targetted code fr=
om
>> >> our machine targetted code, whether that's command line argument pars=
ing,
>> >> or monitor parsing. Maintaining two ways todo the same thing is always
>> >> going to be a maint burden, and in QEMU it has been especially burden=
some
>> >> as they were parallel impls in many cases, rather than one being excl=
usively
>> >> built on top of the other.
>> >>=20
>> >> Even today we still get contributors sending patches which only impl
>> >> HMP code and not QMP code. Separating HMP fully from QMP so that it
>> >> was mandatory to create QMP first gets contributors going down the
>> >> right path, and should reduce the burden on maint.
>> >
>> > Having a separate HMP isn't a bad idea - but it does need some idea of
>> > how to make it easy for contributors to add stuff that's just for debug
>> > or for the dev.   For HMP the bar is very low; if it's useful to the
>> > dev, why not (unless it's copying something that's already in the QMP =
interface
>> > in a different way);  but although the x- stuff in theory lets
>> > you add something via QMP, in practice it's quite hard to get it throu=
gh
>> > review without a lot of QMP design bikeshedding.
>>=20
>> I think this description has become less accurate than it used to be :)
>>=20
>> A long time ago, we started with "QMP is a stable, structured interface
>> for machines, HMP is a plain text interface for humans, and layered on
>> top of QMP."  Layered on top means HMP commands wrap around QMP
>> commands.  Ensures that QMP is obviously complete.  Without such a
>> layering, we'd have to verify completeness by inspection.  Impractical
>> given the size and complexity of the interfaces involved.
>>=20
>> Trouble is there are things in HMP that make no sense in QMP.  For
>> instance, HMP command 'cpu' sets the monitor's default CPU, which
>> certain HMP commands use.  To wrap 'cpu' around a QMP command, we'd have
>> to drag the concept "default CPU" into QMP where it's not wanted.
>
> Surely the isolated HMP monitor code can just keep track of its view
> of a "default" CPU, and then pass an explicit CPU to the QMP commands
> it runs ?

Yes.  It's how HMP works today.



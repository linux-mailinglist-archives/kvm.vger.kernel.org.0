Return-Path: <kvm+bounces-72963-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2JkSF/IGqmldJwEAu9opvQ
	(envelope-from <kvm+bounces-72963-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 23:42:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 344E4218FDA
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 23:42:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id EFBD63006829
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 22:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E77FC3644B7;
	Thu,  5 Mar 2026 22:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eiM6oAwr"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A8E3630B4
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 22:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772750536; cv=none; b=qgYogmaQUtGh1nsdEVn6dpm8qX1d1pshNBn4tkNymCw1yTE5rElCJoRHsfyJS42Rt86e4DJRi7Wl4cj7tXuSfHJxmFB+NzWaaJy5SLZXhXTtHxmnFLiBCY0G3GDP1w7QsTcBe+qGvS70eCfTOkoKULbbjPtjgpWiJgC+CpCuAvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772750536; c=relaxed/simple;
	bh=npSNg3v2yycDEMTtySW0fuZDjyOddQv2uEbrj74QBAc=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=i60ERArAXI84VOxvsybpWWe5sTs//5kVEyjz0t9r4ltyCM10dO+afy/Ak7ajpWnPeB4sfpBlgsWUYvortnj0lcQDEFQSq7e8nX1KX7HTkZeJOt+nOW05joAkf/E7kwifEawyYT+kT39MMOxBm6CKwnHFdr7wYdpEsSbxMJWojXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eiM6oAwr; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=wU669UK/MaDf6Sopmk8cKY+ZtgZpKM9JjNI4MmZZGrM=; b=eiM6oAwrAY23nBseTj6IE02Wyq
	bPE/5VtOh79IO5RAzZlcoYIvBH9GKCTCNeWFg+X3G2dBrk2JQ8nHzVs5bW5v6fgOzbGmo4gUjESea
	1m1EzOW//sY7fIRq4BXOlyhF5cBTA7HyIlfqSOnPp9OJhh8fPRRHkZicTQdBzAaz0eHCMW/H6W/Wg
	MukZteL5f9fwHT1H5uN0z9fl9BZdjH+YBvpFsTjr8h+3C4DQo/nXOQpStvK4o3x2MSd7XssePaBlL
	pwKqsFkOf106/oAxzUGHZUN6WJgxmcldxrzdhGQhypl0DYF7WwLd/BpYeD2HklImfTxozuNspYM++
	zm2UJJcg==;
Received: from business-178-013-028-021.static.arcor-ip.net ([178.13.28.21] helo=ehlo.thunderbird.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vyHOL-00000007j8y-2Gew;
	Thu, 05 Mar 2026 22:42:05 +0000
Date: Thu, 05 Mar 2026 23:42:01 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>, Jim Mattson <jmattson@google.com>
CC: Thijs Raymakers <thijs@raymakers.nl>, kvm@vger.kernel.org,
 Anel Orazgaliyeva <anelkz@amazon.de>, stable <stable@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v3=5D_KVM=3A_x86=3A_use_array=5Findex?=
 =?US-ASCII?Q?=5Fnospec_with_indices_that_come_from_guest?=
User-Agent: K-9 Mail for Android
In-Reply-To: <aaoDtzpY-2y-c-66@google.com>
References: <20250804064405.4802-1-thijs@raymakers.nl> <ac94394405bf7e878c8ff0acf87db922dc4af48c.camel@infradead.org> <CALMp9eTSb3YrLRxnSbYQmAsK1SKA3Job6z2VjUWcKpPOGbWvRw@mail.gmail.com> <aaoDtzpY-2y-c-66@google.com>
Message-ID: <FFDA9F60-F0AD-4A92-8203-40DE82A921A7@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 344E4218FDA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.96 / 15.00];
	SUBJ_EXCESS_QP(1.20)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=desiato.20200630];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72963-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dwmw2@infradead.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On 5 March 2026 23:29:11 CET, Sean Christopherson <seanjc@google=2Ecom> wro=
te:
>On Thu, Mar 05, 2026, Jim Mattson wrote:
>> On Thu, Mar 5, 2026 at 12:31=E2=80=AFPM David Woodhouse <dwmw2@infradea=
d=2Eorg> wrote:
>> >
>> > On Mon, 2025-08-04 at 08:44 +0200, Thijs Raymakers wrote:
>> > > min and dest_id are guest-controlled indices=2E Using array_index_n=
ospec()
>> > > after the bounds checks clamps these values to mitigate speculative=
 execution
>> > > side-channels=2E
>> > >
>> >
>> > (commit c87bd4dd43a6)
>> >
>> > Is this sufficient in the __pv_send_ipi() case?
>> >
>> > > --- a/arch/x86/kvm/lapic=2Ec
>> > > +++ b/arch/x86/kvm/lapic=2Ec
>> > > @@ -852,6 +852,8 @@ static int __pv_send_ipi(unsigned long *ipi_bit=
map, struct kvm_apic_map *map,
>> > >       if (min > map->max_apic_id)
>> > >               return 0;
>> > >
>> > > +     min =3D array_index_nospec(min, map->max_apic_id + 1);
>> > > +
>> > >       for_each_set_bit(i, ipi_bitmap,
>> > >               min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1))=
) {
>> > >               if (map->phys_map[min + i]) {
>> >                         vcpu =3D map->phys_map[min + i]->vcpu;
>> >                         count +=3D kvm_apic_set_irq(vcpu, irq, NULL);
>> >                 }
>> >         }
>> >
>> > Do we need to protect [min + i] in the loop, rather than just [min]?
>> >
>> > The end condition for the for_each_set_bit() loop does mean that it
>> > won't actually execute past max_apic_id but is that sufficient to
>> > protect against *speculative* execution?
>> >
>> > I have a variant of this which uses array_index_nospec(min+i, =2E=2E=
=2E)
>> > *inside* the loop=2E
>>=20
>> Heh=2E Me too!
>
>LOL, OMG, get off your high horses you two and someone send a damn patch!=
 =20

Heh, happy to, but it was actually a genuine question=2E Our pre-embargo p=
atches did it in the loop but the most likely explanation seemed to be that=
 upstream changed it as a valid optimization (because somehow the loop wasn=
't vulnerable?), and that we *can* drop the old patches in favour of the up=
stream one=2E

If no such reason exists for why the patch got changed, I'm happy to post =
the delta=2E


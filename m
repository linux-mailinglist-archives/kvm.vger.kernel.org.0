Return-Path: <kvm+bounces-70626-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cHGPOYkeimmtHAAAu9opvQ
	(envelope-from <kvm+bounces-70626-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:51:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 57045113389
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:51:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0C28E304A595
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 17:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 099A938A713;
	Mon,  9 Feb 2026 17:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TEZcwfym";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y7Oi0DjR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120D62FE579
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 17:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770658940; cv=pass; b=CRvKopMp1DUIpi2VCpMH+EZ5OQ/g5dO9JI56NtHqBwwznbJlUTd8Ji43oonk1KSC7mC/Nk6bBCpP6XKfJzXgCUIgf/gtG36s3QkfWuTK7OyCYoEFaqc+m9lCXhmcPNiu3rh1LWWIuU4V2XbYySvkfPaQOnOtGEIq9mU6gxm5ZqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770658940; c=relaxed/simple;
	bh=tYnc/58oMSwePYKbYYB29B2GpKVgOU1oUltgjmSaV4k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d93hvQL+L8a5nJQRxpasoOWoR4lQCwtBb1cMLVdj80KL/bKHelZtW9/0HfHq97wTVxwbUNjSIadX1/HqkuvPmBvnjeO35P+rP3/RvQYzUH1LewclFeb9+JydACaUxFRKwsG/s9p2QiU7fgOHsKtlJKCI4VAv3PtRD9evTkzTghs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TEZcwfym; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y7Oi0DjR; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770658939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KbVCAw935kDIIxe2lRzdYXFMykx9Cc4ueKoG5k9fyRg=;
	b=TEZcwfymTMWPE1rvksa11R8jUjQuj0wGLPqLSHvEpdCJntOKHjppMvSq/s8SXILERet2zo
	MOBvllvbnt9putJGMFFumVKL0yCfroMD73CrHLdkKeHSJGqYVckni+VRDwCRb7wNAA35RQ
	oC/yaHBG+M8fpAZFBoY5Fgn6rFRBLVc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-yb7k3XCWOha_dDTa74kI4w-1; Mon, 09 Feb 2026 12:42:17 -0500
X-MC-Unique: yb7k3XCWOha_dDTa74kI4w-1
X-Mimecast-MFC-AGG-ID: yb7k3XCWOha_dDTa74kI4w_1770658936
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-435add03f12so1965094f8f.3
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 09:42:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770658936; cv=none;
        d=google.com; s=arc-20240605;
        b=aPK3pm6bfWs3oWN6lGbV/UXbzsQxR522WtDNrLnGHUTLNFNJtEHiHliCezAEXzIvJv
         j9VvOpaMBXcWl8Cai1UaIMlEPUD+1FhUaAPJrJ7FGS8vr5u0TUuXdNo06Z+hDQBiFORM
         YvrPQ7z+fpN4o/WKwHRs9CKoDFpDh35uRzKo9NJo6bUj8ZhIcyPn4LHwI2vz90YZIpVh
         wccYUVHZDCRMZsbzSG8+YMVhCCbAxvmAb5FHfKMUi0QIWZ5Iq8WWeC+s6l7H1TogDFz2
         pBm6O5XooxuPTPvnGf5AkxI5J38VDRdgV6YrmdITo0vNPLYJsMGyj+/eMKlA3IJNug9v
         Cwkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KbVCAw935kDIIxe2lRzdYXFMykx9Cc4ueKoG5k9fyRg=;
        fh=qaYm4b6GKYlZ0T3gtLZ7fjEfCEC8jMv5XzYe6fOhw1Y=;
        b=ZDKRxwne8+Uofk+iXWyrS0dHKvH+0R4N3SYh99OWJQDo9eYmoeDKljX8RQwnZgo1Gn
         J6l4jHFbb2udqBCAeEFRFNmA8u8lKVbNG4S3ZzepPpl6lLxatsjKAnyyJ7ueo8LYwh1w
         3hY0H7Rp0qEUJj0cubmpWakj9HLhMYhqX+vacdOAMZgUcHrNarCshDbBGBc92w+egur2
         I+amSXjTuSdXT7ePUreht0aRzfyn4EhMce5RGl1uXojQx+j8MPH2AbInTww4jfnePowU
         twMUON65bToavEv0mZp1vwQnXzEBMXV3whNWV5D3K2Q8Hz5RGNfUFKSlel5oIkDSAqQ1
         zQBg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770658936; x=1771263736; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KbVCAw935kDIIxe2lRzdYXFMykx9Cc4ueKoG5k9fyRg=;
        b=Y7Oi0DjRu7qd0ih5s0H7YNNu4Gk8Kw/1JXR7h4Vk62Gpd1nvDhEGUI+XVgItPucnF/
         GXrnMLUrRvJnLoED8YgDIgjEUn3S/ZY6U97lwK8GqESpSdshPgPhkiuqP1c0K8/DbOwI
         nCnQIfqyYXoN1zxBI4u73m1c9BXqbQF6TTuFmQTgyP6/7A4qlfT/gzhsEyLoBAhn2MQx
         1rbDNVgr867y6nL+AhGsvdSYjjWhUef12mUSiesdrZhleNAqcdYCf7gt+TTx3ylwuRGK
         ETT88mGWk/L9DFS6DKhty23kkLLZT3nL3aLR53qtQcyTjpdalWIPOKzb+Nn6KSYsWv24
         8n7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770658936; x=1771263736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KbVCAw935kDIIxe2lRzdYXFMykx9Cc4ueKoG5k9fyRg=;
        b=pIwrE87OJ/pW8tGowF0ZKbRpRgxGovA9KuCc4At9HDiYUT+Cmz2RNbBebk95/y5dFo
         vc972pgEjzLqi5Yc0jQpnfDyjs4ldRWUcU+1OdFAtSfCaWbiZDzx7urFyIp9WOFxXoTx
         t3R0E7Qwo4+SXv3o0Ii8dgyDDlX7uz8XJ7DwKfF9GNpK3zknExLtwB5SFyCYJMXpqGey
         an+XFWjiuhhOeFW8LK/3wK4nhS9XDnWlmD4PGzvHvHkhLCpjgupAHypWJwNOMAJu6LbK
         +kQuNmOB9ufPkqxa/Lwew3bo3PSaFPS1isJs7YzESJtMCK1f+UuOG8K/q5qMlEFRqwvP
         4JuA==
X-Gm-Message-State: AOJu0Yy1dDzM/rtOpDosbuR8H/YixGOwoTDqZReYx4GoNUfhPtFO5qhN
	26pRuLIIAZJAmYgtJ7vVxb/chfB+TlUTrh9pJVU+OhM1L09TXjSym3fqVjgVNHXww2zw8relfDl
	219UfZ2qr7uLCt4vr6ahl6R4zcq/J5fflYVoz0jsKLR3v47k26jXBE0cF74HUKcYQRlnCpV1iH4
	jHOuIOoFVplPd/ju8FjasmCUv3KFt8
X-Gm-Gg: AZuq6aJfMCjnDpICXeBtodzA+VakRaDti16bw/UipIarN3qTYPQ8aC962Hc3LXbDFuW
	hqsmw2xTXtvdEsbdByLMotpRw8OsOt+ng4Ut2yCAjvGDc4/FgJNTefmFzGyWzDPXBXKBHd6lJ36
	UixnJWQo3yfb/GMN1XTm2a+ri7w8SYifqZBztCm+0nfwdbvEoTxnBebGXaCrRL8txEFfNOrypRB
	atizzpyiNvOAKWb3GGAua5xo2r0I7QpeL8b0RRxNhIn8xiEXufjskCrl0y51kzmNDJP4g==
X-Received: by 2002:a05:6000:18a6:b0:436:14d2:540c with SMTP id ffacd0b85a97d-43629378545mr18627384f8f.25.1770658936359;
        Mon, 09 Feb 2026 09:42:16 -0800 (PST)
X-Received: by 2002:a05:6000:18a6:b0:436:14d2:540c with SMTP id
 ffacd0b85a97d-43629378545mr18627345f8f.25.1770658935985; Mon, 09 Feb 2026
 09:42:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260207041011.913471-1-seanjc@google.com> <20260207041011.913471-3-seanjc@google.com>
 <CABgObfZeV6D-2cEht1300xNgxYtz=mi6oX4-D8x7exittEe22Q@mail.gmail.com>
In-Reply-To: <CABgObfZeV6D-2cEht1300xNgxYtz=mi6oX4-D8x7exittEe22Q@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 9 Feb 2026 18:42:03 +0100
X-Gm-Features: AZwV_QiqVBlVmFvrmRD9A20gC33blDm0IC8z5nwAmxNzoGq8VurKom8VsE_vxLM
Message-ID: <CABgObfbKh1Tbzv63GfopW3KQhYtfAGgXXBgGn6EiR2kSBgH_jA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: Generic changes for 6.20
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70626-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+]
X-Rspamd-Queue-Id: 57045113389
X-Rspamd-Action: no action

On Mon, Feb 9, 2026 at 6:38=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>
> On Sat, Feb 7, 2026 at 5:10=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> >  - Document that vcpu->mutex is take outside of kvm->slots_lock, which =
is all
> >    kinds of unintuitive, but is unfortunately the existing behavior for
> >    multiple architectures, and in a weird way actually makes sense.
>
> I disagree that it is "arguably wrong" how you put it in the commit
> message. vcpu->mutex is really a "don't worry about multiple ioctls at
> the same time" mutex that tries to stay out of the way.  It only
> becomes unintuitive in special cases like
> tdx_acquire_vm_state_locks().
>
> By itself this would not be a reason to resend, but while at it you
> could mention that vcpu->mutex is taken outside kvm->slots_arch_lock?

... as well as mention kvm_alloc_apic_access_page() in the commit message.

Paolo



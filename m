Return-Path: <kvm+bounces-18527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 525018D6055
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 13:10:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3FDE1F22D17
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41AD4156F5E;
	Fri, 31 May 2024 11:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A0gjG79n"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112F3153BC1
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 11:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717153850; cv=none; b=dinvOQTzD211owZWhrIVz7JGEwUNgIbgBDuO618dwkRq+5QqHJ01zvTKdD41e8PJfQyKWTKxFBsIMcxmlvKtJrN8pasX5bldZ1HbiaKfOjTIs6yT1SF4GEGQqLT/FbGw++RWU0WU4ce2KqklVQofj2g2Aw6kgTk1mffF4zDoeng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717153850; c=relaxed/simple;
	bh=pC8d6E+8ubzcmVOWbjo6N5kdxZdztEnNi5nboI8uU7k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tqrOsP/EN4Tgta0U0FFCnNey/sU5x0n76frH2EXvPQCQy65XmOKOmAqyH8dcWT6OVlEEDd0kSlfPCyrq15rxtHyLYyZdlIPlmLglp1QmjIe6c7kLYZfvUHu/3nmpj9t8kpJZybMyJd1Qlh9uKTRcJpdZCSl7PJZsrzPVoZnfJDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A0gjG79n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717153848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M+s1PzK2/wvRT6JuH6Q8j0YjcXC2Cl53mqKVRaXl/lI=;
	b=A0gjG79nUe9sgBxH14BV3cYWHV7Dk+gh0M6v01T8K95PhnrY6QUbWYlmU02oKYinbEYY0G
	oRtSqMMPnqIo65gwNDjAtgGAWpL61jGoCONjC3FD/stYge4AgebpRkf8gHq6p5lTKwtsEs
	D/cc0s4CD1Ewz0pD8vERuBprpYFQNj0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-mdnI9PydMKaRRWg4NS7Y3A-1; Fri, 31 May 2024 07:10:46 -0400
X-MC-Unique: mdnI9PydMKaRRWg4NS7Y3A-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-35dc02b991eso1153807f8f.0
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 04:10:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717153845; x=1717758645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M+s1PzK2/wvRT6JuH6Q8j0YjcXC2Cl53mqKVRaXl/lI=;
        b=QbLyuLDZVN8SM3PgNWP2iTFufubCgdMKK+lRGnlMBi7cgASpAMowH2Q0lTQnCyaFqp
         IhJJXhZxUXp5diGJdkdAxvTlXH/hdWG5qfPxMdqqAJyjVsPxqI98APVnpRGbcgDVuM1/
         9qy66gvMaGE+pxKmNLMUMc65CZ9pAlulNkbaUZf7AYFaxF0zrvdrV3eDkMA52Yk2+oI6
         rb6HQG0VEuTivTfHH2ufjC4yVFT2j9ZNLP8MAodQtsWs3JOYLalq+2GSOScGKBZamD7P
         IG2W+QwYkAFO7PWMcfUUCd0dPWdmry13VM/1BijETaWrH9es3q2crHAUIDZ9FL0GinqV
         RVNA==
X-Forwarded-Encrypted: i=1; AJvYcCUSi4XpG0dMQcIpQ1gxiod4xTS8UbodkD2PXQhn8AdN8/JJvHH8+r4pwsEhNo9EwIOU56LcPR7kaxQ5V89rEqbHIojM
X-Gm-Message-State: AOJu0YzK71J7QuU2Uz6R4hvhEHb1syzuwubA+J5Xf/zOHIk3+425AEZn
	mNzLFnInf5Xivk3235nr99ZhGA4SJa+JHmwIHfY5ecrU9DXpXQK8Ez0mJq8WzrtQWRwJ6NH6LsG
	hOXnDVzGnzjrjTBmzQiNB6koDCr26qX9kmJnFob3KU0alZYkdPgJWUzInQhFg9BcQ1o1EwY9afT
	OIrd81aQewWC2p/fA327ledHHd
X-Received: by 2002:adf:a196:0:b0:355:21f:be29 with SMTP id ffacd0b85a97d-35e0f258a4bmr1049566f8f.9.1717153845332;
        Fri, 31 May 2024 04:10:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGx/etlVUJlB9WKitCYPHHqZ6AY725KQtDuX2iOQ9gGvuUQYbjyjYV6+5KlxopoiK8PzYToffzVKP0Nb3mspTY=
X-Received: by 2002:adf:a196:0:b0:355:21f:be29 with SMTP id
 ffacd0b85a97d-35e0f258a4bmr1049539f8f.9.1717153844842; Fri, 31 May 2024
 04:10:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com> <20240530111643.1091816-26-pankaj.gupta@amd.com>
In-Reply-To: <20240530111643.1091816-26-pankaj.gupta@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 31 May 2024 13:10:33 +0200
Message-ID: <CABgObfYrg4pJMo9RgY-V5iizviLqWFohPqUUU3wtK5cVHdsS=g@mail.gmail.com>
Subject: Re: [PATCH v4 25/31] i386/sev: Invoke launch_updata_data() for SEV class
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: qemu-devel@nongnu.org, brijesh.singh@amd.com, dovmurik@linux.ibm.com, 
	armbru@redhat.com, michael.roth@amd.com, xiaoyao.li@intel.com, 
	thomas.lendacky@amd.com, isaku.yamahata@intel.com, berrange@redhat.com, 
	kvm@vger.kernel.org, anisinha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 1:17=E2=80=AFPM Pankaj Gupta <pankaj.gupta@amd.com>=
 wrote:
>
> Add launch_update_data() in SevCommonStateClass and
> invoke as sev_launch_update_data() for SEV object.
>
> Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
> ---
>  target/i386/sev.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index c5c703bc8d..7a0c2ee10f 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -102,6 +102,7 @@ struct SevCommonStateClass {
>      /* public */
>      int (*launch_start)(SevCommonState *sev_common);
>      void (*launch_finish)(SevCommonState *sev_common);
> +    int (*launch_update_data)(hwaddr gpa, uint8_t *ptr, uint64_t len);

This should receive the SevCommonState, so that
sev_launch_update_data() does not have to grab it from the
MachineState.

Also,

> -        if (sev_snp_enabled()) {
> -            ret =3D snp_launch_update_data(gpa, ptr, len,
> -                                         KVM_SEV_SNP_PAGE_TYPE_NORMAL);
> -        } else {
> -            ret =3D sev_launch_update_data(SEV_GUEST(sev_common), ptr, l=
en);
> -        }
> +        ret =3D klass->launch_update_data(gpa, ptr, len);

this patch should be placed earlier in the series, so that this change
is done before snp_launch_data() is introduced..

That is, the hunk should be just:

     /* if SEV is in update state then encrypt the data else do nothing */
     if (sev_check_state(sev_common, SEV_STATE_LAUNCH_UPDATE)) {
-        int ret =3D sev_launch_update_data(SEV_GUEST(sev_common), ptr, len=
);
+        int ret;
+
+        ret =3D klass->launch_update_data(SEV_GUEST(sev_common), gpa, ptr,=
 len);
         if (ret < 0) {
             error_setg(errp, "SEV: Failed to encrypt pflash rom");
             return ret;

Paolo



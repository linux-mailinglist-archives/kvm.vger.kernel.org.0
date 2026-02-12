Return-Path: <kvm+bounces-70927-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0LNeMc+RjWl54QAAu9opvQ
	(envelope-from <kvm+bounces-70927-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 09:39:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 171D712B70E
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 09:39:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A90C5303FDEE
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 08:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2224E2D063E;
	Thu, 12 Feb 2026 08:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z5DVxpTG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XTueMm8X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B702AE68
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 08:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770885420; cv=none; b=S/bqOTB21oAw+e0qMwYOCkRwDy9TvvNfkqjGujp2RnbPpa6FppmQvq+8gHUiRk0Lkk/8e/1oOACpRXY93FGmxp2qsf51u2IdaaXivGjSvOHIhJtZ9OxaK9whwVJ1i/IACr6tguebj8UKrfOPvWyIHUSxp3KJEIOMVFHA2u3oN6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770885420; c=relaxed/simple;
	bh=3pSVSWG28uDJ+gerbIU3JtJfiOnGKVM0jhY1THKvHSg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Yh+58TDxIlB51URlti1RpyZuNXcaOd+Dh2clybZaMrTR0yGuEkaCGxMIAbvM7sdipE8S5jH2A8wBI8w7JFonXzMPBdWNZ/frih3iPglZNETLFF0eScPrVnoBxyw8OPDSH2eidPiIbCATZcWsBE36sH8ukfuW8UE6It+9Oz2wUrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z5DVxpTG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XTueMm8X; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770885418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8S28mvsxUwXYzebAuxeqnovFXr3Jd2l2hZVxQKKrLYk=;
	b=Z5DVxpTGkp7oEWSVlZFf8ZDF+9vU3nDBY3d0QtEjR/8f3Pj70ZnA1VDta/FGggDe0HDFZg
	4cK2YY5Fo6Ra2a9TkDOQ4VJCuTopauAgkDu8YBBS8xOW1cgfTfg0pwNIKpMEsQGPTGh/01
	xYsV1M/ryD8HN0b+YmHdmbPk8oM+nCU=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-KTB-tQt_PJ2IVmf37Q3cRQ-1; Thu, 12 Feb 2026 03:36:56 -0500
X-MC-Unique: KTB-tQt_PJ2IVmf37Q3cRQ-1
X-Mimecast-MFC-AGG-ID: KTB-tQt_PJ2IVmf37Q3cRQ_1770885416
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8230d6d54a5so1406825b3a.1
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 00:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770885415; x=1771490215; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8S28mvsxUwXYzebAuxeqnovFXr3Jd2l2hZVxQKKrLYk=;
        b=XTueMm8XryalrwUTOcs2OaovCnQiE2bpS/8z6IGia13RcTtTZ5j9l0H4OCb5j+IW/J
         kyDCczit2Aj4cw0AfFHRVinZwZATXxybgPxDASc8nQauBv8iAH2JWL321HHwwqI0S3RY
         PZZuqTivXr3gkvpT7pqUTxZEDaOoovKrpnb0Lpd4zYTP6eTEOe5neTyIEwyvb4DBDg6b
         DeYTcBifp7shvKN8+dXkDeszONXVtPtbNW1ZQF+meQX6uqgvjQIkrDCJrormejMWC/pD
         SWFAlrIpNifTimLNHbhlrpR0K7j636SEavMC49658+/butjtFvHdS+VTti+TFIZDYv0Q
         9KuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770885415; x=1771490215;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8S28mvsxUwXYzebAuxeqnovFXr3Jd2l2hZVxQKKrLYk=;
        b=j23oRJeCTilenVD3yC365jg2M3z5Lx5vnEBmJF6nfHdi4Qoh8slbNSKoDueaPjjqEn
         kPLaldUTo8AxeUnyeRYjD/QTD7PutbuhyeV3XB4OW0FjbVRVmYqbByXobI2RiSPtrbLs
         gvc24W/qA7X3lC02uv3ZRnBZu0NTNWCUVWm22rFjzk9Yis9ceydkh5Udfud2/jtE3z6v
         MsHQO/nk53D/v2XlIGokXOJiDTQ+x/iABpflpkS2ZcSZE97rCQOC3GisF0HzONW/gxbV
         L0b2SWf2OTfxG6Lse7MTTXRnZoyO9ofKLIdq71GsgGNNwuvV9yYSYlKMWdB7c7YhhWfk
         93Dg==
X-Forwarded-Encrypted: i=1; AJvYcCWF0Cl3pKKKsYZij1LVM2hchFF7zgZJzKpNcCeCppoy6v8cBgI5Sk+N/WfvcBrQkxdXmNI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoJugGy1b47P3dSEx06CHCDkHyQ64XvgcjwXojBB4D1HpDj+2x
	qHEVlPIpPgF1FzGkERt67B3bInEh5z2z5XvhfLrbv2oo13KpWPlzSXN/3QMoLpUhSOdx6KpqpKg
	CxvURcl4MDHucmnfAh6HTWh1nr8G+1aADMScptFtFVJlK9VcLMhAwRhVJBMJ9xw==
X-Gm-Gg: AZuq6aKnMzot4JLPGY9WQjkxqj/tgQdZe0A8a5EC8FmZbiOWnklfSnYAetdmy66Do95
	AwWRuecISgO2kjILpPg1BBPJtut04Vnf9IA5OCT2cgN9dz0zNF9VHvMN6P8mY3ELgignNcN38PK
	gm77kLb6YaEUoKs3r6NlXgq/awSPpI1P6I3iL5zVYjvWPNhjHejyfyoDnM4uha5FyuiRbO1SYv/
	XbQFASBvLfp6clZAI+ssgh3UD+Yg0KIJp0IDveb0gGtD3WLJEDql0K1JWaPVo/LJg6Db1Eg/n7X
	eUPbdOwaMiGGKASIhLxCjzkjhdK91CJlXJcrdgWDmd/vE2W95QrJxrKFMz12jVrtpIL66rJLNGJ
	/kx+I/w2gUkmZxxkjiBgOmjZvCyDVHZZWXBW6lObsCm0Dbsh4Szs2DlNmlGAHabZw98MBjA==
X-Received: by 2002:a05:6a20:c90e:b0:371:8e6d:27f9 with SMTP id adf61e73a8af0-3944a70c127mr1558728637.33.1770885415671;
        Thu, 12 Feb 2026 00:36:55 -0800 (PST)
X-Received: by 2002:a05:6a20:c90e:b0:371:8e6d:27f9 with SMTP id adf61e73a8af0-3944a70c127mr1558716637.33.1770885415279;
        Thu, 12 Feb 2026 00:36:55 -0800 (PST)
Received: from smtpclient.apple ([122.164.27.113])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6e1967ca7esm4180279a12.3.2026.02.12.00.36.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Feb 2026 00:36:54 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.4\))
Subject: Re: [PATCH v4 17/31] i386/sev: add migration blockers only once
From: Ani Sinha <anisinha@redhat.com>
In-Reply-To: <CAE8KmOwa1M_F9Qfs-XXRhaJZx7jiwQDfwDk7U2shJi8SLa+y9Q@mail.gmail.com>
Date: Thu, 12 Feb 2026 14:06:39 +0530
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>,
 Gerd Hoffmann <kraxel@redhat.com>,
 kvm@vger.kernel.org,
 qemu-devel <qemu-devel@nongnu.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6C39045F-DF1E-4E9A-8ECB-AE24C766F002@redhat.com>
References: <20260212062522.99565-1-anisinha@redhat.com>
 <20260212062522.99565-18-anisinha@redhat.com>
 <CAE8KmOwa1M_F9Qfs-XXRhaJZx7jiwQDfwDk7U2shJi8SLa+y9Q@mail.gmail.com>
To: Prasad Pandit <ppandit@redhat.com>
X-Mailer: Apple Mail (2.3826.700.81.1.4)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_FROM(0.00)[bounces-70927-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 171D712B70E
X-Rspamd-Action: no action



> On 12 Feb 2026, at 1:20=E2=80=AFPM, Prasad Pandit <ppandit@redhat.com> =
wrote:
>=20
> On Thu, 12 Feb 2026 at 11:58, Ani Sinha <anisinha@redhat.com> wrote:
>> sev_launch_finish() and sev_snp_launch_finish() could be called =
multiple times
>> when the confidential guest is being reset/rebooted. The migration
>> blockers should not be added multiple times, once per invocation. =
This change
>> makes sure that the migration blockers are added only one time by =
adding the
>> migration blockers to the vm state change handler when the vm =
transitions to
>> the running state. Subsequent reboots do not change the state of the =
vm.
>>=20
>> Signed-off-by: Ani Sinha <anisinha@redhat.com>
>> ---
>> target/i386/sev.c | 20 +++++---------------
>> 1 file changed, 5 insertions(+), 15 deletions(-)
>>=20
>> diff --git a/target/i386/sev.c b/target/i386/sev.c
>> index 66e38ca32e..260d8ef88b 100644
>> --- a/target/i386/sev.c
>> +++ b/target/i386/sev.c
>> @@ -1421,11 +1421,6 @@ sev_launch_finish(SevCommonState *sev_common)
>>     }
>>=20
>>     sev_set_guest_state(sev_common, SEV_STATE_RUNNING);
>> -
>> -    /* add migration blocker */
>> -    error_setg(&sev_mig_blocker,
>> -               "SEV: Migration is not implemented");
>> -    migrate_add_blocker(&sev_mig_blocker, &error_fatal);
>> }
>>=20
>> static int snp_launch_update_data(uint64_t gpa, void *hva, size_t =
len,
>> @@ -1608,7 +1603,6 @@ static void
>> sev_snp_launch_finish(SevCommonState *sev_common)
>> {
>>     int ret, error;
>> -    Error *local_err =3D NULL;
>>     OvmfSevMetadata *metadata;
>>     SevLaunchUpdateData *data;
>>     SevSnpGuestState *sev_snp =3D SEV_SNP_GUEST(sev_common);
>> @@ -1655,15 +1649,6 @@ sev_snp_launch_finish(SevCommonState =
*sev_common)
>>=20
>>     kvm_mark_guest_state_protected();
>>     sev_set_guest_state(sev_common, SEV_STATE_RUNNING);
>> -
>> -    /* add migration blocker */
>> -    error_setg(&sev_mig_blocker,
>> -               "SEV-SNP: Migration is not implemented");
>> -    ret =3D migrate_add_blocker(&sev_mig_blocker, &local_err);
>> -    if (local_err) {
>> -        error_report_err(local_err);
>> -        exit(1);
>> -    }
>> }
>>=20
>>=20
>> @@ -1676,6 +1661,11 @@ sev_vm_state_change(void *opaque, bool =
running, RunState state)
>>     if (running) {
>>         if (!sev_check_state(sev_common, SEV_STATE_RUNNING)) {
>>             klass->launch_finish(sev_common);
>> +
>> +            /* add migration blocker */
>> +            error_setg(&sev_mig_blocker,
>> +                       "SEV: Migration is not implemented");
>> +            migrate_add_blocker(&sev_mig_blocker, &error_fatal);
>>         }
>>     }
>> }
>> --
>=20
> * 'sev_mig_blocker' is a global static variable, so it's the same
> blocker (address) added each time, maybe add_blocker() should do a
> check to avoid duplicates.

Maybe we could do something like this (I have not tested it) but perhaps =
outside the scope of this change set:

diff --git a/migration/migration.c b/migration/migration.c
index b103a82fc0..7d85821315 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -1696,8 +1696,11 @@ static int add_blockers(Error **reasonp, unsigned =
modes, Error **errp)
 {
     for (MigMode mode =3D 0; mode < MIG_MODE__MAX; mode++) {
         if (modes & BIT(mode)) {
-            migration_blockers[mode] =3D =
g_slist_prepend(migration_blockers[mode],
-                                                       *reasonp);
+            if (g_slist_index(migration_blockers[mode],
+                                 *reasonp) =3D=3D -1) {
+                migration_blockers[mode] =3D =
g_slist_prepend(migration_blockers[mode],
+                                                           *reasonp);
+            }
         }
     }
     return 0;


>=20
> * Otherwise it looks okay.
> Reviewed-by: Prasad Pandit <pjp@fedoraproject.org>
>=20
> Thank you.
> ---
>  - Prasad
>=20



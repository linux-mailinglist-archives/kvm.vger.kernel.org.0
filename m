Return-Path: <kvm+bounces-71344-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8Mj/N4LmlmkuqwIAu9opvQ
	(envelope-from <kvm+bounces-71344-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 11:31:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 47DB515DCC1
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 11:31:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CF616301AF42
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 10:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 514F4329C7B;
	Thu, 19 Feb 2026 10:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a8rlNmhH";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sZbdISIF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A2172634
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 10:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771497082; cv=none; b=ZluziJ9fJE6S9r047CaXg8KH8NuCnunOclmQOFp2+X59lM9SwvQU0wORmasBniLuO96nrwWlTsJsKUURlTGT1AV9kUdCfFF8cF3LvPrnJBMHrJK+Oe9/UNgCW34wn+uaQ4zfxRrH0VKO1qRrdotzf/bCLcgPNHtMtiTFegfnUSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771497082; c=relaxed/simple;
	bh=fvHHqqBjkECPXcooImIOYCgGKhVCIfhccwvW3L2T/Ec=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=YRMAzWeQU9op3iF/D3DH4jqOHN7t+Wrv4J9MkvZfsbqPKXbZC4/gNz6MOr6YWOPuAV2MxJ+chKjY+JqmntuSncAx/18Mpr+FLJWzUF3aYkEknEs83E7nI2Hrhyey5VREc9WKzzZNhc3/2PQ+A4D6zDN4GdTeQvmknZJIji8X+FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a8rlNmhH; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sZbdISIF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771497080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LyQNA8MfxC+gdRaJejrXp5+qJYC1z7cZ1QgL2HRqhmA=;
	b=a8rlNmhH6epL/5YdrPiWJnlZZG03pCBk9McpUxZfc6g8Lasj3UJqaB2Z6ZuzNqb5RsQhKz
	ctQHMC4scPzFM2yzeNpjB2shPfD/SXa5lodbqXFe71wBGRTSB/u/TYJpc+DFSy824HGNS5
	SmykSw5inTsQuj5ed/mtg/u4VVVnKAg=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-711--KDcmFmtOI2p-mKN1TtZOQ-1; Thu, 19 Feb 2026 05:31:18 -0500
X-MC-Unique: -KDcmFmtOI2p-mKN1TtZOQ-1
X-Mimecast-MFC-AGG-ID: -KDcmFmtOI2p-mKN1TtZOQ_1771497077
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2aad6045810so7954145ad.3
        for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 02:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771497077; x=1772101877; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LyQNA8MfxC+gdRaJejrXp5+qJYC1z7cZ1QgL2HRqhmA=;
        b=sZbdISIFA2jWmRvao0ZJ4iYucrVeuftZI6GmvI1WIOZRCmvZgXqVs1kgMb0f7Nj2sM
         JS56OdYddgBuyd3kuWEOWaCFx0rGGb2r1WYYOCKxv9xX2tH1HHnTkP8oh3Xj+qTSc0kq
         jiAlc4ymNnmjYfstPTxgRGDhd2DHOoPsYeRC+TYktFA0b5NnCJxwOxm34qBf9nJfgDlA
         X38w1pk/HsKADrOeQ4d1y52z+BbvT/y3nn38UWiFVGWdtnYfZ1Bn2S11kmdQ3SSbpe5M
         Fl0SKM6uqqwdxILkdQ/ZOU137t4P649+W/gKfQ4zTJu+kXlTpAgcMrAvjUzLlpm00pfE
         J9dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771497077; x=1772101877;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LyQNA8MfxC+gdRaJejrXp5+qJYC1z7cZ1QgL2HRqhmA=;
        b=JIby0V9vVZC/5nQIKnAz0D2ewN1lo5PSfTvOznpdqU5HHobF1Az+Tq4uOpuT7cGnnd
         2BO6B7T2BMVOcQHDK+3AGZtqiP7zK0i8X80bNRkkC1s2q0NmonhSL7lLCPh/ngww04EH
         YLhu6+sd7sJpAuRfDp5w7Evf4pE493EOJaFYDFzBjxfHVhHXPJH2xKzw56PfH2wfOxjC
         TG5PHCW4LhOkfD+W+yGegDGJkDWKLVIFfgpdhCoef7HSanPJDmwc1J66JaA4ut/VqW3v
         2U8ax8fKHqgHjbo4sYfrXvUA5Fs2ycs6AYclRJOOSsLNQatog8MZs3ccaZs9GvhWmGxW
         rvsg==
X-Forwarded-Encrypted: i=1; AJvYcCWFXeoBeba7PhagadQAAgOSfmUUe9Xu5b4Q3CsxvJf68Hsdh31Vp0Pj910i8LSrZSb9njk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxWkyu3AWpLGOI8VulxJD+1MJ4SaJ/g4UUbuRp+Ozd8Q2WwhBV
	6MSXnUzePEAwELyoFH6Qm61kMGJXKaZzeC+oJbHOwCr918VWiXYppTGVrZcTErqeYzZN2EQ1nEA
	5ZK65QiihsorAmsQ/DLBBUzPp9xjINOBT4TKjcsXzMhNj+CLNOAfq9A==
X-Gm-Gg: AZuq6aJX1m+zKVo/4FFLPkgPPnb8cEBN9TWRfHVTs0o1shvhFvLhvYE2FMwnboend4E
	Yo7oea6kuDtENmv0XiIhAeR7TSA89jqZhrnBxNgpXv3PoBAIWd+tZSmG4VR7jtwVUKzITfq21FV
	wLY9k7UZAIe43NR2Wyfl8+jm+GYe8kUrGUIG/Hk5pxcEL6pGVYT7q/xbukYPB9HYG6ur5F5PT5E
	1W20JygV1x5Uf/XTWyaW5xOJTOFUZZmDunvLbMkJtrpEnIMcUYzbtH2UmZtAPVTJ2JcKq0bgmP1
	EujVLkczrc0tY4YX6EbRNNLWWfbII2Pc+Z2197jNA/1CF4yCYw+BtkPkXVDxEWS/Lwc38itWROw
	2hzqQd7uxMZhzOtS6MZCfpCcxx56GGzOJK5i78/cYWaILx3Cm3f30KumCKBt7qiW8T3c=
X-Received: by 2002:a17:903:2a85:b0:2aa:e3f7:a945 with SMTP id d9443c01a7336-2ad50fb5db7mr45393435ad.49.1771497077484;
        Thu, 19 Feb 2026 02:31:17 -0800 (PST)
X-Received: by 2002:a17:903:2a85:b0:2aa:e3f7:a945 with SMTP id d9443c01a7336-2ad50fb5db7mr45393105ad.49.1771497077034;
        Thu, 19 Feb 2026 02:31:17 -0800 (PST)
Received: from smtpclient.apple ([117.99.83.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1aaeab38sm157285875ad.82.2026.02.19.02.31.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Feb 2026 02:31:16 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.4\))
Subject: Re: [PATCH v5 27/34] kvm/xen-emu: re-initialize capabilities during
 confidential guest reset
From: Ani Sinha <anisinha@redhat.com>
In-Reply-To: <3b4b7b7b-7fcd-46ce-bdcb-cd1a30cf5276@xen.org>
Date: Thu, 19 Feb 2026 16:01:02 +0530
Cc: David Woodhouse <dwmw2@infradead.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 Gerd Hoffmann <kraxel@redhat.com>,
 kvm@vger.kernel.org,
 qemu-devel <qemu-devel@nongnu.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <793B549F-F866-4BF5-ABAF-A0537BA8713B@redhat.com>
References: <20260218114233.266178-1-anisinha@redhat.com>
 <20260218114233.266178-28-anisinha@redhat.com>
 <3b4b7b7b-7fcd-46ce-bdcb-cd1a30cf5276@xen.org>
To: Paul Durrant <xadimgnik@gmail.com>
X-Mailer: Apple Mail (2.3826.700.81.1.4)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71344-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 47DB515DCC1
X-Rspamd-Action: no action



> On 19 Feb 2026, at 3:09=E2=80=AFPM, Paul Durrant <xadimgnik@gmail.com> =
wrote:
>=20
> On 18/02/2026 11:42, Ani Sinha wrote:
>> On confidential guests KVM virtual machine file descriptor changes as =
a
>> part of the guest reset process. Xen capabilities needs to be =
re-initialized in
>> KVM against the new file descriptor.
>> Signed-off-by: Ani Sinha <anisinha@redhat.com>
>> ---
>>  target/i386/kvm/xen-emu.c | 50 =
+++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 48 insertions(+), 2 deletions(-)
>> diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
>> index 52de019834..69527145eb 100644
>> --- a/target/i386/kvm/xen-emu.c
>> +++ b/target/i386/kvm/xen-emu.c
>> @@ -44,9 +44,12 @@
>>    #include "xen-compat.h"
>>  +NotifierWithReturn xen_vmfd_change_notifier;
>> +static bool hyperv_enabled;
>>  static void xen_vcpu_singleshot_timer_event(void *opaque);
>>  static void xen_vcpu_periodic_timer_event(void *opaque);
>>  static int vcpuop_stop_singleshot_timer(CPUState *cs);
>> +static int do_initialize_xen_caps(KVMState *s, uint32_t =
hypercall_msr);
>>    #ifdef TARGET_X86_64
>>  #define hypercall_compat32(longmode) (!(longmode))
>> @@ -54,6 +57,30 @@ static int vcpuop_stop_singleshot_timer(CPUState =
*cs);
>>  #define hypercall_compat32(longmode) (false)
>>  #endif
>>  +static int xen_handle_vmfd_change(NotifierWithReturn *n,
>> +                                  void *data, Error** errp)
>> +{
>> +    int ret;
>> +
>> +    /* we are not interested in pre vmfd change notification */
>> +    if (((VmfdChangeNotifier *)data)->pre) {
>> +        return 0;
>> +    }
>> +
>> +    ret =3D do_initialize_xen_caps(kvm_state, XEN_HYPERCALL_MSR);
>> +    if (ret < 0) {
>> +        return ret;
>> +    }
>> +
>> +    if (hyperv_enabled) {
>> +        ret =3D do_initialize_xen_caps(kvm_state, =
XEN_HYPERCALL_MSR_HYPERV);
>> +        if (ret < 0) {
>> +            return ret;
>> +        }
>> +    }
>> +    return 0;
>=20
> This seems odd. Why use the hyperv_enabled boolean, rather than simply =
the msr value, since when hyperv_enabled is set you will be calling =
do_initialize_xen_caps() twice.

I am not sure of enabling capabilities for Xen. I assumed we need to =
call kvm_xen_init() twice, once normally with XEN_HYPERCALL_MSR and if =
hyper is enabled, again with XEN_HYPERCALL_MSR_HYPERV. Is that not the =
case? Is it one or the other but not both? It seems kvm_arch_init() =
calls kvm_xen_init() once with XEN_HYPERCALL_MSR and another time =
vcpu_arch_init() calls it again if hyperv is enabled with =
XEN_HYPERCALL_MSR_HYPERV .

>=20
>> +}
>> +
>>  static bool kvm_gva_to_gpa(CPUState *cs, uint64_t gva, uint64_t =
*gpa,
>>                             size_t *len, bool is_write)
>>  {
>> @@ -111,15 +138,16 @@ static inline int kvm_copy_to_gva(CPUState *cs, =
uint64_t gva, void *buf,
>>      return kvm_gva_rw(cs, gva, buf, sz, true);
>>  }
>>  -int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
>> +static int do_initialize_xen_caps(KVMState *s, uint32_t =
hypercall_msr)
>>  {
>> +    int xen_caps, ret;
>>      const int required_caps =3D KVM_XEN_HVM_CONFIG_HYPERCALL_MSR |
>>          KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL | =
KVM_XEN_HVM_CONFIG_SHARED_INFO;
>> +
>=20
> Gratuitous whitespace change.
>=20
>>      struct kvm_xen_hvm_config cfg =3D {
>>          .msr =3D hypercall_msr,
>>          .flags =3D KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
>>      };
>> -    int xen_caps, ret;
>>        xen_caps =3D kvm_check_extension(s, KVM_CAP_XEN_HVM);
>>      if (required_caps & ~xen_caps) {
>> @@ -143,6 +171,21 @@ int kvm_xen_init(KVMState *s, uint32_t =
hypercall_msr)
>>                       strerror(-ret));
>>          return ret;
>>      }
>> +    return xen_caps;
>> +}
>> +
>> +int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
>> +{
>> +    int xen_caps;
>> +
>> +    xen_caps =3D do_initialize_xen_caps(s, hypercall_msr);
>> +    if (xen_caps < 0) {
>> +        return xen_caps;
>> +    }
>> +
>=20
> Clearly here the code would be simpler here if you just saved the =
value of hypercall_msr which you have used in the call above.
>=20
>> +    if (!hyperv_enabled && (hypercall_msr =3D=3D =
XEN_HYPERCALL_MSR_HYPERV)) {
>> +        hyperv_enabled =3D true;
>> +    }
>>        /* If called a second time, don't repeat the rest of the =
setup. */
>>      if (s->xen_caps) {
>> @@ -185,6 +228,9 @@ int kvm_xen_init(KVMState *s, uint32_t =
hypercall_msr)
>>      xen_primary_console_reset();
>>      xen_xenstore_reset();
>>  +    xen_vmfd_change_notifier.notify =3D xen_handle_vmfd_change;
>> +    kvm_vmfd_add_change_notifier(&xen_vmfd_change_notifier);
>> +
>>      return 0;
>>  }




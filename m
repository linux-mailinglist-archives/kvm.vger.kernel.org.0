Return-Path: <kvm+bounces-46133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0331CAB2FB5
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 08:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A7C47A6123
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 06:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27D59255F3C;
	Mon, 12 May 2025 06:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SWrfVCZx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC3E248F6F
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 06:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747031701; cv=none; b=sDK3V7QhQCcB3F/OYK9V2VwNVoFgkv+/Itbx99n+m5Cjlvwg/eS4WwcZ/efEBtPQWRbZuy63PHk+HCr6fFE1k8CHNpErJ5QQcmzX4EPfIWSz1+S29ZPJ2caHgx2E78lhTgppcNHujVnn+lcJbL1qAlrDWEQM56P7M2uKf0WZuJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747031701; c=relaxed/simple;
	bh=1oiddZuagxhA1ZyvVtWxso+0kPyobtELQNbDKsUCadg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=AysXblGYai0wXJDHfOnHYM0faYyWfoUOUqb1TKbsO3uYZW+z5jQumaFWAf5LxdrToUfJCwogXA7GvTKhqMKqU0ce1GPkkT7XidG2xGCP5Gtfd3eKstsR+9sjGnZKYRD/dwN+aGz6lXnL885jkoJbC6LcyG0vwgGqjN7QfWzANQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SWrfVCZx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747031697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=natpKHXNFNFKQUWTeJGwNh7Gg+YeikwA5L3IRAwW6PU=;
	b=SWrfVCZxEmgGHjRrLPNEF49FcaBBK7HO1Jgw0Os1IVZ781D4O8MQ5l+EZCC/gOHl0UL2Nf
	m0i8Ye1TJh2ZSy9nL/tpEQ0CNdLoYUsNor2wohS4RvQipF/unEMs8hUuQi7rOnrV9prRpj
	Du356hksYK0Hbsfew34vKmUh9HMVZuY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-MX620s8OMBq5RhpUJ_HC0A-1; Mon,
 12 May 2025 02:34:55 -0400
X-MC-Unique: MX620s8OMBq5RhpUJ_HC0A-1
X-Mimecast-MFC-AGG-ID: MX620s8OMBq5RhpUJ_HC0A_1747031692
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C3E71800264;
	Mon, 12 May 2025 06:34:51 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.27])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0AB541956058;
	Mon, 12 May 2025 06:34:48 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 769C921E66C2; Mon, 12 May 2025 08:34:46 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,  Xiaoyao Li <xiaoyao.li@intel.com>,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Markus
 Armbruster
 <armbru@redhat.com>,  Paolo Bonzini <pbonzini@redhat.com>,  "Daniel P.
 Berrange" <berrange@redhat.com>,  qemu-devel@nongnu.org,  Richard
 Henderson <richard.henderson@linaro.org>,  kvm@vger.kernel.org,  Gerd
 Hoffmann <kraxel@redhat.com>,  Peter Maydell <peter.maydell@linaro.org>,
  Laurent Vivier <lvivier@redhat.com>,  Jiaxun Yang
 <jiaxun.yang@flygoat.com>,  Yi Liu <yi.l.liu@intel.com>,  "Michael S.
 Tsirkin" <mst@redhat.com>,  Eduardo Habkost <eduardo@habkost.net>,  Marcel
 Apfelbaum <marcel.apfelbaum@gmail.com>,  Alistair Francis
 <alistair.francis@wdc.com>,  Daniel Henrique Barboza
 <dbarboza@ventanamicro.com>,  Marcelo Tosatti <mtosatti@redhat.com>,
  qemu-riscv@nongnu.org,  Weiwei Li <liwei1518@gmail.com>,  Amit Shah
 <amit@kernel.org>,  Yanan Wang <wangyanan55@huawei.com>,  Helge Deller
 <deller@gmx.de>,  Palmer Dabbelt <palmer@dabbelt.com>,  Ani Sinha
 <anisinha@redhat.com>,  Igor Mammedov <imammedo@redhat.com>,  Fabiano
 Rosas <farosas@suse.de>,  Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
  =?utf-8?Q?Cl=C3=A9ment?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
  qemu-arm@nongnu.org,  =?utf-8?Q?Marc-Andr=C3=A9?= Lureau
 <marcandre.lureau@redhat.com>,
  Huacai Chen <chenhuacai@kernel.org>,  Jason Wang <jasowang@redhat.com>
Subject: Re: How to mark internal properties
In-Reply-To: <2f526570-7ab0-479c-967c-b3f95f9f19e3@redhat.com> (Thomas Huth's
	message of "Fri, 9 May 2025 12:04:19 +0200")
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-13-philmd@linaro.org>
	<23260c74-01ba-45bc-bf2f-b3e19c28ec8a@intel.com>
	<aB2vjuT07EuO6JSQ@intel.com>
	<2f526570-7ab0-479c-967c-b3f95f9f19e3@redhat.com>
Date: Mon, 12 May 2025 08:34:46 +0200
Message-ID: <87selauyk9.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Thomas Huth <thuth@redhat.com> writes:

> On 09/05/2025 09.32, Zhao Liu wrote:
>> On Fri, May 09, 2025 at 02:49:27PM +0800, Xiaoyao Li wrote:
>>> Date: Fri, 9 May 2025 14:49:27 +0800
>>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Subject: Re: [PATCH v4 12/27] target/i386/cpu: Remove
>>>   CPUX86State::enable_cpuid_0xb field
>>>
>>> On 5/8/2025 9:35 PM, Philippe Mathieu-Daud=C3=A9 wrote:
>>>> The CPUX86State::enable_cpuid_0xb boolean was only disabled
>>>> for the pc-q35-2.6 and pc-i440fx-2.6 machines, which got
>>>> removed. Being now always %true, we can remove it and simplify
>>>> cpu_x86_cpuid().
>>>>
>>>> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>>>> ---
>>>> target/i386/cpu.h | 3 ---
>>>> target/i386/cpu.c | 6 ------
>>>> 2 files changed, 9 deletions(-)
>>>>
>>>> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
>>>> index 0db70a70439..06817a31cf9 100644
>>>> --- a/target/i386/cpu.h
>>>> +++ b/target/i386/cpu.h
>>>> @@ -2241,9 +2241,6 @@ struct ArchCPU {
>>>>       */
>>>>      bool legacy_multi_node;
>>>> -    /* Compatibility bits for old machine types: */
>>>> -    bool enable_cpuid_0xb;
>>>> -
>>>>      /* Enable auto level-increase for all CPUID leaves */
>>>>      bool full_cpuid_auto_level;
>>>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>>>> index 49179f35812..6fe37f71b1e 100644
>>>> --- a/target/i386/cpu.c
>>>> +++ b/target/i386/cpu.c
>>>> @@ -6982,11 +6982,6 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t i=
ndex, uint32_t count,
>>>>          break;
>>>>      case 0xB:
>>>>            /* Extended Topology Enumeration Leaf */
>>>> -        if (!cpu->enable_cpuid_0xb) {
>>>> -            *eax =3D *ebx =3D *ecx =3D *edx =3D 0;
>>>> -            break;
>>>> -        }
>>>> -
>>>>          *ecx =3D count & 0xff;
>>>>          *edx =3D cpu->apic_id;
>>>> @@ -8828,7 +8823,6 @@ static const Property x86_cpu_properties[] =3D {
>>>>      DEFINE_PROP_UINT64("ucode-rev", X86CPU, ucode_rev, 0),
>>>>      DEFINE_PROP_BOOL("full-cpuid-auto-level", X86CPU, full_cpuid_auto=
_level, true),
>>>>      DEFINE_PROP_STRING("hv-vendor-id", X86CPU, hyperv_vendor),
>>>> -    DEFINE_PROP_BOOL("cpuid-0xb", X86CPU, enable_cpuid_0xb, true),
>>>
>>> It's deprecating the "cpuid-0xb" property.
>>>
>>> I think we need go with the standard process to deprecate it.
>>=20
>> Thanks! I got your point.
>>=20
>> Though this property is introduced for compatibility, as its comment
>> said "Compatibility bits for old machine types", it is also useful for
>> somer users.
>
> Thanks for your clarifications, Zhao! But I think this shows again the=20
> problem that we have hit a couple of times in the past already: Propertie=
s=20
> are currently used for both, config knobs for the users and internal=20
> switches for configuration of the machine. We lack a proper way to say "t=
his=20
> property is usable for the user" and "this property is meant for internal=
=20
> configuration only".

Correct.

Exposing properties meant for internal use at the external interface
inevitably leads to (uncertainty about) external use.

> I wonder whether we could maybe come up with a naming scheme to better=20
> distinguish the two sets, e.g. by using a prefix similar to the "x-" pref=
ix=20
> for experimental properties? We could e.g. say that all properties starti=
ng=20
> with a "q-" are meant for QEMU-internal configuration only or something=20
> similar (and maybe even hide those from the default help output when runn=
ing=20
> "-device xyz,help" ?)? Anybody any opinions or better ideas on this?

This papers over our inability / unwillingness to isolate the external
interface from internal detail.

The proper solution is to make the internal properties inaccessible at
the external interface.  This requires declaring properties' intent.
Which strikes me as a very good idea.

A naming convention is a simple, stupid way to do that.  There are
drawbacks, as experience with the "x-" prefix has shown:

* Flipping a flag bit involves changing the name.  Tolerable when all
  uses are internal, compatibility break when not.  Not a problem when
  the bit governs external access, of course.

* Name capture: consider InputBarrier properties x-origin, y-origin.
  Oops.

* If we have multiple flag bits, their prefixes can accumulate.  This
  gets ugly and confusing real quick.  Not an issue when at most one of
  the flags can be set, as is the case for "unstable" and "internal
  use".

* QAPI reserves "q_" for the generator's use.  Since "q-" would get
  mapped to "q_" in C, we risk name clashes.

For what it's worth, QAPI abandoned the "x-" naming convention (commit
a3c45b3e629 (qapi: New special feature flag "unstable"), commit message
appended for your convenience).  Developers are free to use "x-" to help
guide human users, but the feature flag is the sole source of thruth.



[...]



commit a3c45b3e62962f99338716b1347cfb0d427cea44
Author: Markus Armbruster <armbru@redhat.com>
Date:   Thu Oct 28 12:25:12 2021 +0200

    qapi: New special feature flag "unstable"
=20=20=20=20
    By convention, names starting with "x-" are experimental.  The parts
    of external interfaces so named may be withdrawn or changed
    incompatibly in future releases.
=20=20=20=20
    The naming convention makes unstable interfaces easy to recognize.
    Promoting something from experimental to stable involves a name
    change.  Client code needs to be updated.  Occasionally bothersome.
=20=20=20=20
    Worse, the convention is not universally observed:
=20=20=20=20
    * QOM type "input-barrier" has properties "x-origin", "y-origin".
      Looks accidental, but it's ABI since 4.2.
=20=20=20=20
    * QOM types "memory-backend-file", "memory-backend-memfd",
      "memory-backend-ram", and "memory-backend-epc" have a property
      "x-use-canonical-path-for-ramblock-id" that is documented to be
      stable despite its name.
=20=20=20=20
    We could document these exceptions, but documentation helps only
    humans.  We want to recognize "unstable" in code, like "deprecated".
=20=20=20=20
    So support recognizing it the same way: introduce new special feature
    flag "unstable".  It will be treated specially by the QAPI generator,
    like the existing feature flag "deprecated", and unlike regular
    feature flags.
=20=20=20=20
    This commit updates documentation and prepares tests.  The next commit
    updates the QAPI schema.  The remaining patches update the QAPI
    generator and wire up -compat policy checking.
=20=20=20=20
    Management applications can then use query-qmp-schema and -compat to
    manage or guard against use of unstable interfaces the same way as for
    deprecated interfaces.
=20=20=20=20
    docs/devel/qapi-code-gen.txt no longer mandates the naming convention.
    Using it anyway might help writers of programs that aren't
    full-fledged management applications.  Not using it can save us
    bothersome renames.  We'll see how that shakes out.
=20=20=20=20
    Signed-off-by: Markus Armbruster <armbru@redhat.com>
    Reviewed-by: Juan Quintela <quintela@redhat.com>
    Reviewed-by: John Snow <jsnow@redhat.com>
    Message-Id: <20211028102520.747396-2-armbru@redhat.com>



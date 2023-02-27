Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D2A6A45AE
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 16:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjB0PNO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 10:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjB0PNM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 10:13:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E81D21A20
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 07:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677510748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1N24a9jHrr8aJ2RFQYYJuZ0zIDzBlJZkBj9a2PQXJok=;
        b=UUVNrlENpOcfkajvEe7bX/rjdg0GvawSxnMn59T64r9SLt6FQILE6knBhTh+HAVRdLBcdP
        RhTYQpyQ9tZeuV5+ekVzA4tu81szZmRICW3YZffmiBlPYrpiSaKCCqSRPLaMn+ATrK/kOO
        fhH0Y70qjEBcWsl2A9aSLP+T0kUe+7s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-qaFv04jzNlem9IXZUjZ_uQ-1; Mon, 27 Feb 2023 10:12:24 -0500
X-MC-Unique: qaFv04jzNlem9IXZUjZ_uQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3123188646A;
        Mon, 27 Feb 2023 15:12:24 +0000 (UTC)
Received: from localhost (unknown [10.45.226.217])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DE3DA40C6EC4;
        Mon, 27 Feb 2023 15:12:23 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Auger <eauger@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: Re: [PATCH v5 2/3] arm/kvm: add support for MTE
In-Reply-To: <877cwun51m.fsf@redhat.com>
Organization: Red Hat GmbH
References: <20230203134433.31513-1-cohuck@redhat.com>
 <20230203134433.31513-3-cohuck@redhat.com>
 <da118de5-adcd-ec0c-9870-454c3741a4ab@linaro.org>
 <071ec3a6-cb4b-0dac-87fd-f3c3d00b5e83@redhat.com>
 <877cwun51m.fsf@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 27 Feb 2023 16:12:22 +0100
Message-ID: <871qmb5ei1.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 06 2023, Cornelia Huck <cohuck@redhat.com> wrote:

> On Mon, Feb 06 2023, Eric Auger <eauger@redhat.com> wrote:
>
>> Hi,
>>
>> On 2/3/23 21:40, Richard Henderson wrote:
>>> On 2/3/23 03:44, Cornelia Huck wrote:
>>>> +static void aarch64_cpu_get_mte(Object *obj, Visitor *v, const char
>>>> *name,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void *opaque, Error **errp)
>>>> +{
>>>> +=C2=A0=C2=A0=C2=A0 ARMCPU *cpu =3D ARM_CPU(obj);
>>>> +=C2=A0=C2=A0=C2=A0 OnOffAuto mte =3D cpu->prop_mte;
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 visit_type_OnOffAuto(v, name, &mte, errp);
>>>> +}
>>>=20
>>> You don't need to copy to a local variable here.
>>>=20
>>>> +
>>>> +static void aarch64_cpu_set_mte(Object *obj, Visitor *v, const char
>>>> *name,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void *opaque, Error **errp)
>>>> +{
>>>> +=C2=A0=C2=A0=C2=A0 ARMCPU *cpu =3D ARM_CPU(obj);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 visit_type_OnOffAuto(v, name, &cpu->prop_mte, errp=
);
>>>> +}
>>>=20
>>> ... which makes get and set functions identical.
>>> No need for both.
>> This looks like a common pattern though. virt_get_acpi/set_acpi in
>> virt.c or pc_machine_get_vmport/set_vmport in i386/pc.c and many other
>> places (microvm ...). Do those other callers also need some simplificati=
ons?
>
> Indeed, I'm pretty sure that I copied + adapted it from somewhere :)
>
> Should we clean up all instances in one go instead? (Probably on top of
> this series, in order to minimize conflicts with other changes.)

Any objections to going with the code above and just doing a general
cleanup on top?


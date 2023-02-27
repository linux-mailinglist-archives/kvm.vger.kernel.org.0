Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4DC6A459F
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 16:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjB0PLu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 10:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjB0PLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 10:11:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB7E212AB
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 07:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677510666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NVUY/CD/XYh7Ejxe1GNd/WPYDalUCINsIUkTkVEPc6Y=;
        b=Fas5w4vSjFDOoKw/W6MimYYicHvXlFitJwYxtGpyad4S7FsHiaRax/8cC0vJmvxumH4wLx
        6Sc3mSpTLqtgffUzQSPhu0VimrGAI1pPDzZqpv+XQ23WLmR54YwMw+SkUTKHkrA4kRh8qr
        I3BNqlSGxZv70D52b7zR1KnOJVQr4EY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-XPL_wHSoNz6McJcezda3HQ-1; Mon, 27 Feb 2023 10:11:03 -0500
X-MC-Unique: XPL_wHSoNz6McJcezda3HQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE0FF3C0E445;
        Mon, 27 Feb 2023 15:11:02 +0000 (UTC)
Received: from localhost (unknown [10.45.226.217])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A81222166B2B;
        Mon, 27 Feb 2023 15:11:02 +0000 (UTC)
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
In-Reply-To: <f24a826e-2f90-d23a-c3f3-5985e90814f2@redhat.com>
Organization: Red Hat GmbH
References: <20230203134433.31513-1-cohuck@redhat.com>
 <20230203134433.31513-3-cohuck@redhat.com>
 <ecddd3a1-f4e4-4cc8-3294-8c94aca28ed0@redhat.com>
 <14188fd3-6e97-3e00-7d54-7f76e53eeb22@linaro.org>
 <f24a826e-2f90-d23a-c3f3-5985e90814f2@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 27 Feb 2023 16:11:01 +0100
Message-ID: <874jr75eka.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15 2023, Eric Auger <eauger@redhat.com> wrote:

> Hi Richard,
> On 2/6/23 19:27, Richard Henderson wrote:
>> On 2/6/23 03:32, Eric Auger wrote:
>>>> +void kvm_arm_enable_mte(Error **errp)
>>>> +{
>>>> +=C2=A0=C2=A0=C2=A0 static bool tried_to_enable =3D false;
>>>> +=C2=A0=C2=A0=C2=A0 Error *mte_migration_blocker =3D NULL;
>>> can't you make the mte_migration_blocker static instead?
>>>
>>>> +=C2=A0=C2=A0=C2=A0 int ret;
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 if (tried_to_enable) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * MTE on KVM is enab=
led on a per-VM basis (and retrying
>>>> doesn't make
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * sense), and we onl=
y want a single migration blocker as well.
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>>> +=C2=A0=C2=A0=C2=A0 }
>>>> +=C2=A0=C2=A0=C2=A0 tried_to_enable =3D true;
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 if ((ret =3D kvm_vm_enable_cap(kvm_state, KVM_CAP_=
ARM_MTE, 0))) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error_setg_errno(errp, -re=
t, "Failed to enable
>>>> KVM_CAP_ARM_MTE");
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>>> +=C2=A0=C2=A0=C2=A0 }
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 /* TODO: add proper migration support with MTE ena=
bled */
>>>> +=C2=A0=C2=A0=C2=A0 error_setg(&mte_migration_blocker,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 "Live migration disabled due to MTE enabled");
>>=20
>> Making the blocker static wouldn't stop multiple errors from
>> kvm_vm_enable_cap.
> Sorry I don't get what you mean. instead of checking tried_to_enable why
> can't we check !mte_migration_blocker?

[missed this one]

Do you mean

if (mte_migration_blocker) {
    return;
}

error_setg(&mte_migration_blocker, ...);

if ((ret =3D kvm_vm_enable_cap(...))) {
    return;
}

if (migrate_add_blocker(...)) {
    error_free(mte_migration_blocker);
    // is mte_migration_blocker guaranteed !=3D NULL here?
}


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361D8697A5B
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 12:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbjBOLAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 06:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjBOLAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 06:00:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501ED2D178
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 02:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676458755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z1vm4rRSwi9q0BCc8utZUgURv9fQkg9JJyOqtW+jBlQ=;
        b=Nbk14g1UyFJ3w/MLjXmBTRz8YS1s6+HvopAZJUvYQV9UGVIOdxEEoYuU1gRaVAatjrO3Dh
        78MAkh6VbZdNBDDMnvvlT59PgUDbZYzwj/cNLMFZ1WWEN0NVWVjE01HQZjyOSdbF+SGWD0
        US5v82V5WMK5TqsYO83arg9kRC864DA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-DGET8La2Nii-4pQFBs3PVA-1; Wed, 15 Feb 2023 05:59:12 -0500
X-MC-Unique: DGET8La2Nii-4pQFBs3PVA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 635AA85CCE4;
        Wed, 15 Feb 2023 10:59:11 +0000 (UTC)
Received: from localhost (unknown [10.39.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F3CFB2166B30;
        Wed, 15 Feb 2023 10:59:10 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Auger <eauger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v5 3/3] qtests/arm: add some mte tests
In-Reply-To: <a7904d6e-c8e5-055b-34f7-8ea2956ec65f@redhat.com>
Organization: Red Hat GmbH
References: <20230203134433.31513-1-cohuck@redhat.com>
 <20230203134433.31513-4-cohuck@redhat.com>
 <a7904d6e-c8e5-055b-34f7-8ea2956ec65f@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Wed, 15 Feb 2023 11:59:09 +0100
Message-ID: <874jrndwjm.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
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

On Mon, Feb 06 2023, Eric Auger <eauger@redhat.com> wrote:

> Hi,
>
> On 2/3/23 14:44, Cornelia Huck wrote:
>> @@ -517,6 +583,13 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
>>          assert_set_feature(qts, "host", "pmu", false);
>>          assert_set_feature(qts, "host", "pmu", true);
>>  
>> +        /*
>> +         * Unfortunately, there's no easy way to test whether this instance
>> +         * of KVM supports MTE. So we can only assert that the feature
>> +         * is present, but not whether it can be toggled.
>> +         */
>> +        assert_has_feature(qts, "host", "mte");
> I know you replied in v4 but I am still confused:
> What does
>       (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
> return on a MTE capable host and and on a non MTE capable host?

FWIW, it's "auto" in both cases, but the main problem is actually
something else...

>
> If I remember correctly qmp_query_cpu_model_expansion loops over the
> advertised features and try to set them explicitly so if the host does
> not support it this should fail and the result should be different from
> the case where the host supports it (even if it is off by default)
>
> Does assert_has_feature_enabled() returns false?

I poked around a bit with qmp on a system (well, model) with MTE where
starting a guest with MTE works just fine. I used the minimal setup
described in docs/devel/writing-monitor-commands.rst, and trying to do a
cpu model expansion with mte=on fails because the KVM ioctl fails with
-EINVAL (as we haven't set up proper memory mappings). The qtest setup
doesn't do any proper setup either AFAICS, so enabling MTE won't work
even if KVM and the host support it. (Trying to enable MTE on a host
that doesn't support it would also report an error, but a different one,
as KVM would not support the MTE cap at all.) We don't really know
beforehand what to expect ("auto" is not yet expanded, see above), so
I'm not sure how to test this in a meaningful way, even if we did set up
memory mappings (which seems like overkill for a feature test.)

The comment describing this could be improved, though :)


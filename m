Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28EEF60F079
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 08:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbiJ0GmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 02:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiJ0GmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 02:42:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DAF1707B
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 23:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666852933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XS3ic0iCUvn5ho/53uIrFNHi7ZNbpesOuXtxAnsqiX4=;
        b=Nqe4NDRuqYLLUirYiPAI5yCnC60/MYXUuUGXfGiwjFV7R/gt+DXzRNneeUSyAM/BJnGfz4
        GIPODjpIzgYOh65npnFteVmKb8csSEI/iAC1Ni6C9+U70drNMetNwVK7xqM/W1gVXyqx4C
        OpFu8NNnsGRPffz3XDNC4JYXAox3yZA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-270-gxn5zhgrOuubBRz2XMtapg-1; Thu, 27 Oct 2022 02:42:05 -0400
X-MC-Unique: gxn5zhgrOuubBRz2XMtapg-1
Received: by mail-wm1-f70.google.com with SMTP id r18-20020a05600c35d200b003cb2ba79692so256293wmq.5
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 23:42:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XS3ic0iCUvn5ho/53uIrFNHi7ZNbpesOuXtxAnsqiX4=;
        b=JGiuQ5ybFF7tJOiZK44a3Og4HKWjKENX71B36DOhPW1ZopfyvrSmiV58LIYtV7tXvz
         +TYXtRcv0OGOo//hwkbckKqIch0EUNhBQDlB6dxjBE54czTdKFsMWsFIfjfmssLxdEfy
         Qk6Ou/YOXeI5wydz/dLuBptCumIBx50qLZt6p60hMmBXAIfMDsmCx+N2QitGxzpbDwbE
         xGc9Cemnb4uqQamy35r89HQj26CbgIYLiGq/Rvf84+p0b0TaLeH0AESaQdnm7lJUuBjm
         C2z9dO9a8Qrj4W33butKDf88flvJ0im0DZ4jZgFWYDgK9WaNWoFljssGrB+estFdsKgY
         vRlQ==
X-Gm-Message-State: ACrzQf2/mo4JgGGvmxl4+rTxCioT1LqFVglw8hs7gdAavtdpmcSeFs85
        IBcLWCeE0pPaHuB4Y5McCRiWqHNXfeEIF8hSHUHnDtVWL63k8JoBIW4/GZ1ryeNi/DR36pU2KnS
        8nvwvFZAba2ZZ
X-Received: by 2002:adf:c7d1:0:b0:236:7cde:a9b5 with SMTP id y17-20020adfc7d1000000b002367cdea9b5mr8668713wrg.381.1666852924270;
        Wed, 26 Oct 2022 23:42:04 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7MYmH4O1N8t97lPe6oZ1KZ0uy22V/IBAjSIZsCk97sDO9SaNmtgbPcbQDa8GVpW1AFeAoVCg==
X-Received: by 2002:adf:c7d1:0:b0:236:7cde:a9b5 with SMTP id y17-20020adfc7d1000000b002367cdea9b5mr8668695wrg.381.1666852923965;
        Wed, 26 Oct 2022 23:42:03 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-176-195.web.vodafone.de. [109.43.176.195])
        by smtp.gmail.com with ESMTPSA id t8-20020a05600c198800b003cf490d1cf7sm4096597wmq.8.2022.10.26.23.42.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 23:42:03 -0700 (PDT)
Message-ID: <bfd29635-9742-741c-a6dc-145bcf4f8ef8@redhat.com>
Date:   Thu, 27 Oct 2022 08:42:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 2/2] qtests/arm: add some mte tests
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>
References: <20221026160511.37162-1-cohuck@redhat.com>
 <20221026160511.37162-3-cohuck@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20221026160511.37162-3-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/10/2022 18.05, Cornelia Huck wrote:
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   tests/qtest/arm-cpu-features.c | 76 ++++++++++++++++++++++++++++++++++
>   1 file changed, 76 insertions(+)
> 
> diff --git a/tests/qtest/arm-cpu-features.c b/tests/qtest/arm-cpu-features.c
> index 5a145273860c..e264d2178a8b 100644
> --- a/tests/qtest/arm-cpu-features.c
> +++ b/tests/qtest/arm-cpu-features.c
> @@ -22,6 +22,7 @@
>   
>   #define MACHINE     "-machine virt,gic-version=max -accel tcg "
>   #define MACHINE_KVM "-machine virt,gic-version=max -accel kvm -accel tcg "
> +#define MACHINE_MTE "-machine virt,gic-version=max,mte=on -accel tcg "
>   #define QUERY_HEAD  "{ 'execute': 'query-cpu-model-expansion', " \
>                       "  'arguments': { 'type': 'full', "
>   #define QUERY_TAIL  "}}"
> @@ -155,6 +156,18 @@ static bool resp_get_feature(QDict *resp, const char *feature)
>       g_assert(qdict_get_bool(_props, feature) == (expected_value));     \
>   })
>   
> +#define resp_assert_feature_str(resp, feature, expected_value)         \
> +({                                                                     \
> +    QDict *_props;                                                     \
> +                                                                       \
> +    g_assert(_resp);                                                   \
> +    g_assert(resp_has_props(_resp));                                   \
> +    _props = resp_get_props(_resp);                                    \
> +    g_assert(qdict_get(_props, feature));                              \
> +    g_assert_cmpstr(qdict_get_try_str(_props, feature), ==,            \
> +                    expected_value);                                   \
> +})
> +
>   #define assert_feature(qts, cpu_type, feature, expected_value)         \
>   ({                                                                     \
>       QDict *_resp;                                                      \
> @@ -165,6 +178,16 @@ static bool resp_get_feature(QDict *resp, const char *feature)
>       qobject_unref(_resp);                                              \
>   })
>   
> +#define assert_feature_str(qts, cpu_type, feature, expected_value)     \
> +({                                                                     \
> +    QDict *_resp;                                                      \
> +                                                                       \
> +    _resp = do_query_no_props(qts, cpu_type);                          \
> +    g_assert(_resp);                                                   \
> +    resp_assert_feature_str(_resp, feature, expected_value);           \
> +    qobject_unref(_resp);                                              \
> +})
> +
>   #define assert_set_feature(qts, cpu_type, feature, value)              \
>   ({                                                                     \
>       const char *_fmt = (value) ? "{ %s: true }" : "{ %s: false }";     \
> @@ -176,6 +199,16 @@ static bool resp_get_feature(QDict *resp, const char *feature)
>       qobject_unref(_resp);                                              \
>   })
>   
> +#define assert_set_feature_str(qts, cpu_type, feature, value, _fmt)    \
> +({                                                                     \
> +    QDict *_resp;                                                      \
> +                                                                       \
> +    _resp = do_query(qts, cpu_type, _fmt, feature);                    \
> +    g_assert(_resp);                                                   \
> +    resp_assert_feature_str(_resp, feature, value);                    \
> +    qobject_unref(_resp);                                              \
> +})
> +
>   #define assert_has_feature_enabled(qts, cpu_type, feature)             \
>       assert_feature(qts, cpu_type, feature, true)
>   
> @@ -412,6 +445,24 @@ static void sve_tests_sve_off_kvm(const void *data)
>       qtest_quit(qts);
>   }
>   
> +static void mte_tests_tag_memory_on(const void *data)
> +{
> +    QTestState *qts;
> +
> +    qts = qtest_init(MACHINE_MTE "-cpu max");
> +
> +    /*
> +     * With tag memory, "mte" should default to on, and explicitly specifying
> +     * either on or off should be fine.
> +     */
> +    assert_has_feature(qts, "max", "mte");
> +
> +    assert_set_feature_str(qts, "max", "mte", "off", "{ 'mte': 'off' }");
> +    assert_set_feature_str(qts, "max", "mte", "on", "{ 'mte': 'on' }");
> +
> +    qtest_quit(qts);
> +}
> +
>   static void pauth_tests_default(QTestState *qts, const char *cpu_type)
>   {
>       assert_has_feature_enabled(qts, cpu_type, "pauth");
> @@ -424,6 +475,21 @@ static void pauth_tests_default(QTestState *qts, const char *cpu_type)
>                    "{ 'pauth': false, 'pauth-impdef': true }");
>   }
>   
> +static void mte_tests_default(QTestState *qts, const char *cpu_type)
> +{
> +    assert_has_feature(qts, cpu_type, "mte");
> +
> +    /*
> +     * Without tag memory, mte will be off under tcg.
> +     * Explicitly enabling it yields an error.
> +     */
> +    assert_has_feature(qts, cpu_type, "mte");
> +
> +    assert_set_feature_str(qts, "max", "mte", "off", "{ 'mte': 'off' }");
> +    assert_error(qts, cpu_type, "mte=on requires tag memory",
> +                 "{ 'mte': 'on' }");
> +}
> +
>   static void test_query_cpu_model_expansion(const void *data)
>   {
>       QTestState *qts;
> @@ -473,6 +539,7 @@ static void test_query_cpu_model_expansion(const void *data)
>   
>           sve_tests_default(qts, "max");
>           pauth_tests_default(qts, "max");
> +        mte_tests_default(qts, "max");
>   
>           /* Test that features that depend on KVM generate errors without. */
>           assert_error(qts, "max",
> @@ -516,6 +583,13 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
>           assert_set_feature(qts, "host", "pmu", false);
>           assert_set_feature(qts, "host", "pmu", true);
>   
> +        /*
> +         * Unfortunately, there's no easy way to test whether this instance
> +         * of KVM supports MTE. So we can only assert that the feature
> +         * is present, but not whether it can be toggled.
> +         */
> +        assert_has_feature(qts, "host", "mte");
> +
>           /*
>            * Some features would be enabled by default, but they're disabled
>            * because this instance of KVM doesn't support them. Test that the
> @@ -630,6 +704,8 @@ int main(int argc, char **argv)
>                               NULL, sve_tests_sve_off);
>           qtest_add_data_func("/arm/kvm/query-cpu-model-expansion/sve-off",
>                               NULL, sve_tests_sve_off_kvm);
> +        qtest_add_data_func("/arm/max/query-cpu-model-expansion/tag-memory",
> +                            NULL, mte_tests_tag_memory_on);

Is it already possible to compile qemu-system-aarch64 with --disable-tcg ? 
If so, I'd recommend a qtest_has_accel("tcg") here ... but apart from that:

Acked-by: Thomas Huth <thuth@redhat.com>



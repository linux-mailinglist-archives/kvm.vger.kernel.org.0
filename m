Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91D268C5B0
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 19:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjBFSYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 13:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBFSYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 13:24:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B521E2943A
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 10:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675707807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FWuHJM2vrIVPSRC7Cm3a4a5SQKoCxaLOmsMZq298YuY=;
        b=Y46TaRlheISz6/OndgfwE5MAykoeJKdW0JxoqleBPxy0Cg0/LYmfWKeKa8KG+/ZAXWBo7+
        P51F9ou/RVV0KOAyWjETnKPWadxwxuIcNzbN3xf7LPgwqZvIGkwb8obzlCxVhmJ8IGgN2a
        SJX9qIQ1TPKKqts2MNjDxavaFbbjI/c=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-460-r_DrNPgQOA2XDTmD3UJJlA-1; Mon, 06 Feb 2023 13:23:26 -0500
X-MC-Unique: r_DrNPgQOA2XDTmD3UJJlA-1
Received: by mail-qt1-f197.google.com with SMTP id g9-20020ac80709000000b003ba266c0c2bso1742248qth.5
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 10:23:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FWuHJM2vrIVPSRC7Cm3a4a5SQKoCxaLOmsMZq298YuY=;
        b=0yl62KEZKwGzqXQTVho5T38WC99l/dzRLD0+DsHS/mYmlY3SvJpwd8juWGFpFWC9Rf
         NaIzGsxYHOCFMV6o/8ibRCxDU+uNA8nVyMn9T6OUjn4bo7F1DkG+BZGcmP4Tj99d/lov
         rGXXHoiZQal/CRjh6hWSRqh5WCmq6rj19iRzlg9qCtdS2IG3hvQbA6M9L/WbuZUQDuGC
         bhRy0ZGoyet8ZxwwHF0Hi+aTdzt+gTqyV0hCSQWZb/twGQyHDaecYzTj+tQ7jQinUODQ
         yp+ichfSKcj5gS34G/RQ6XtQj2OzaQlTppvQmyVBd8PsX1IGiMHgRVwS2pVMbuLrSQQK
         TiCg==
X-Gm-Message-State: AO0yUKV3yf8gQ+VGCtjcrf5ttVzmws5OTijtLXgpQliyo+eTg+dZFPfW
        3Ukl20M2ommqhj/DE81o32fuivnDAtkGtKrjVq7GC2Mq/5HIs/1Zb47vi+k9KEyVivtU4wu/vB3
        /LFpi2tQ/Hego
X-Received: by 2002:ac8:5cce:0:b0:3b9:a777:3d9a with SMTP id s14-20020ac85cce000000b003b9a7773d9amr365562qta.44.1675707801073;
        Mon, 06 Feb 2023 10:23:21 -0800 (PST)
X-Google-Smtp-Source: AK7set9upyWyQNzZQNL2//97uMLT5rQuhHnQlYpG3uOax4T9gPQKwlC9A6Q4lnq5rBaCQ1vyDHcx0w==
X-Received: by 2002:ac8:5cce:0:b0:3b9:a777:3d9a with SMTP id s14-20020ac85cce000000b003b9a7773d9amr365519qta.44.1675707800716;
        Mon, 06 Feb 2023 10:23:20 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l9-20020ae9f009000000b007069fde14a6sm7323856qkg.25.2023.02.06.10.23.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 10:23:19 -0800 (PST)
Message-ID: <a7904d6e-c8e5-055b-34f7-8ea2956ec65f@redhat.com>
Date:   Mon, 6 Feb 2023 19:23:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v5 3/3] qtests/arm: add some mte tests
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
References: <20230203134433.31513-1-cohuck@redhat.com>
 <20230203134433.31513-4-cohuck@redhat.com>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20230203134433.31513-4-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/3/23 14:44, Cornelia Huck wrote:
> Acked-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>

Still as you need to respin I think adding a short commit msg wouldn't
hurt ;-) Add new cpu MTE feature tests with TCG+virt tag memory and
TCG-no tag memory (default) attempting to set cpu mte option on/off. No
real test for KVM because ../..
> ---
>  tests/qtest/arm-cpu-features.c | 75 ++++++++++++++++++++++++++++++++++
>  1 file changed, 75 insertions(+)
> 
> diff --git a/tests/qtest/arm-cpu-features.c b/tests/qtest/arm-cpu-features.c
> index 8691802950ca..c5dbf66e938a 100644
> --- a/tests/qtest/arm-cpu-features.c
> +++ b/tests/qtest/arm-cpu-features.c
> @@ -22,6 +22,7 @@
>  
>  #define MACHINE     "-machine virt,gic-version=max -accel tcg "
>  #define MACHINE_KVM "-machine virt,gic-version=max -accel kvm -accel tcg "
> +#define MACHINE_MTE "-machine virt,gic-version=max,mte=on -accel tcg "
>  #define QUERY_HEAD  "{ 'execute': 'query-cpu-model-expansion', " \
>                      "  'arguments': { 'type': 'full', "
>  #define QUERY_TAIL  "}}"
> @@ -156,6 +157,18 @@ static bool resp_get_feature(QDict *resp, const char *feature)
>      g_assert(qdict_get_bool(_props, feature) == (expected_value));     \
>  })
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
>  #define assert_feature(qts, cpu_type, feature, expected_value)         \
>  ({                                                                     \
>      QDict *_resp;                                                      \
> @@ -166,6 +179,16 @@ static bool resp_get_feature(QDict *resp, const char *feature)
>      qobject_unref(_resp);                                              \
>  })
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
>  #define assert_set_feature(qts, cpu_type, feature, value)              \
>  ({                                                                     \
>      const char *_fmt = (value) ? "{ %s: true }" : "{ %s: false }";     \
> @@ -177,6 +200,17 @@ static bool resp_get_feature(QDict *resp, const char *feature)
>      qobject_unref(_resp);                                              \
>  })
>  
Not really related to your series but those macros become increasingly
difficult to follow. Especially the feature param versus format that are
partly redundant look weird: "mte", "off", "{ 'mte': 'off' }

Starting adding comments may help the reading.
> +#define assert_set_feature_str(qts, cpu_type, feature, value, _fmt)    \
> +({                                                                     \
> +    const char *__fmt = _fmt;                                          \
> +    QDict *_resp;                                                      \
> +                                                                       \
> +    _resp = do_query(qts, cpu_type, __fmt, feature);                   \
> +    g_assert(_resp);                                                   \
> +    resp_assert_feature_str(_resp, feature, value);                    \
> +    qobject_unref(_resp);                                              \
> +})
> +
>  #define assert_has_feature_enabled(qts, cpu_type, feature)             \
>      assert_feature(qts, cpu_type, feature, true)
>  
> @@ -413,6 +447,24 @@ static void sve_tests_sve_off_kvm(const void *data)
>      qtest_quit(qts);
>  }
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
the above comment rather applies to assert_set_feature_str's, right?
> +    assert_has_feature(qts, "max", "mte");
> +
> +    assert_set_feature_str(qts, "max", "mte", "off", "{ 'mte': 'off' }");
> +    assert_set_feature_str(qts, "max", "mte", "on", "{ 'mte': 'on' }");
> +
> +    qtest_quit(qts);
> +}
> +
>  static void pauth_tests_default(QTestState *qts, const char *cpu_type)
>  {
>      assert_has_feature_enabled(qts, cpu_type, "pauth");
> @@ -425,6 +477,19 @@ static void pauth_tests_default(QTestState *qts, const char *cpu_type)
>                   "{ 'pauth': false, 'pauth-impdef': true }");
>  }
>  
> +static void mte_tests_default(QTestState *qts, const char *cpu_type)
> +{
> +    assert_has_feature(qts, cpu_type, "mte");
> +
> +    /*
> +     * Without tag memory, mte will be off under tcg.
> +     * Explicitly enabling it yields an error.
> +     */
> +    assert_set_feature_str(qts, "max", "mte", "off", "{ 'mte': 'off' }");
> +    assert_error(qts, cpu_type, "mte=on requires tag memory",
> +                 "{ 'mte': 'on' }");
Sorry in v4 I reported I preferred the pauth msg, clarifying now:

    assert_error(qts, cpu_type, "cannot enable pauth-impdef without pauth",
                 "{ 'pauth': false, 'pauth-impdef': true }");

Here would translate into cannot enable mte without tag memory.

> +}
> +
>  static void test_query_cpu_model_expansion(const void *data)
>  {
>      QTestState *qts;
> @@ -474,6 +539,7 @@ static void test_query_cpu_model_expansion(const void *data)
>  
>          sve_tests_default(qts, "max");
>          pauth_tests_default(qts, "max");
> +        mte_tests_default(qts, "max");
>  
>          /* Test that features that depend on KVM generate errors without. */
>          assert_error(qts, "max",
> @@ -517,6 +583,13 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
>          assert_set_feature(qts, "host", "pmu", false);
>          assert_set_feature(qts, "host", "pmu", true);
>  
> +        /*
> +         * Unfortunately, there's no easy way to test whether this instance
> +         * of KVM supports MTE. So we can only assert that the feature
> +         * is present, but not whether it can be toggled.
> +         */
> +        assert_has_feature(qts, "host", "mte");
I know you replied in v4 but I am still confused:
What does
      (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
return on a MTE capable host and and on a non MTE capable host?

If I remember correctly qmp_query_cpu_model_expansion loops over the
advertised features and try to set them explicitly so if the host does
not support it this should fail and the result should be different from
the case where the host supports it (even if it is off by default)

Does assert_has_feature_enabled() returns false?

Thanks

Eric


> +
>          /*
>           * Some features would be enabled by default, but they're disabled
>           * because this instance of KVM doesn't support them. Test that the
> @@ -631,6 +704,8 @@ int main(int argc, char **argv)
>                              NULL, sve_tests_sve_off);
>          qtest_add_data_func("/arm/kvm/query-cpu-model-expansion/sve-off",
>                              NULL, sve_tests_sve_off_kvm);
> +        qtest_add_data_func("/arm/max/query-cpu-model-expansion/tag-memory",
> +                            NULL, mte_tests_tag_memory_on);
>      }
>  
>      return g_test_run();


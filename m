Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD33748236
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 12:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbjGEKdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 06:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjGEKdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 06:33:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C4FE63
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 03:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688553141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kahp1TYXfK3xFb5kDtYp3xFLKu91U0oYiaYra3jA+Ok=;
        b=VcaNm/l5U14Q+ffWA01TpsPb+eaY+2wATjRHvggjqPOfU779LIggrjhN6WOmMl9CPdOxuL
        r8vxzlkbcbdMW8H+0PH3TE8DsIen9YVw+MxDtcqLL7B2/GxHPkGexwBXaYXIfXgeAlLEug
        4315MwfQsynKCnqzpgq7beN326y6i6k=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-4qseZ7fHNI6Ut3Ekc2wCHQ-1; Wed, 05 Jul 2023 06:32:20 -0400
X-MC-Unique: 4qseZ7fHNI6Ut3Ekc2wCHQ-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7659b44990eso557135285a.1
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 03:32:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688553140; x=1691145140;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kahp1TYXfK3xFb5kDtYp3xFLKu91U0oYiaYra3jA+Ok=;
        b=H2mx/x6Xxis/18MbsFM9BBqW+PmrYXiKupczZNw8s24FEs+CuB5GA0HWa5FavlkjoX
         O0NvadTZgfMjL1u3+sU/7BRBqDiIkEkRbrJPPemzGN/3SULsGiM7uVKg7qgW4Q0DPgMC
         40ETQyM+wCm+8zp0Frhl9dKOHXmL2CgZdzGjWQgpMVx5od5dFl33H4nABnK47pQdhnW/
         JrUivlKV+no6YNDZOEngPAAK8SmIS2ZEWoO6rsXEa+WUNavoeUa7lcJp7h3SiGfvKOfs
         IES8GtgvDPNuVIGfzRY37jcuvec3B5q3JHnvELLzc3IIxyouenzPUoR6v61+Iks24Li6
         XrNw==
X-Gm-Message-State: AC+VfDw9XNV7nrGn1rXJcbPQPEGYBTnpMxE3BwU4XfW93y8/DN7l5OkB
        7Wh65av19eQf31bpnwtJlfCaVjyFbi8XmTXhRJnvz+wyazFYpjGQxbLzu9mSr53EyBy7hO4szEE
        0lDIN+M2IVn68
X-Received: by 2002:a05:620a:2a14:b0:767:15ee:cc51 with SMTP id o20-20020a05620a2a1400b0076715eecc51mr18686055qkp.6.1688553139984;
        Wed, 05 Jul 2023 03:32:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7u4eKFfMzAChBGZiqwciT2EqJ38wfkBY6Dtz/orTBUdImYSABG2EapIz6ck93aENU8yKbu2Q==
X-Received: by 2002:a05:620a:2a14:b0:767:15ee:cc51 with SMTP id o20-20020a05620a2a1400b0076715eecc51mr18686044qkp.6.1688553139698;
        Wed, 05 Jul 2023 03:32:19 -0700 (PDT)
Received: from [10.33.192.205] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id oo26-20020a05620a531a00b0076715ec99dbsm8554926qkn.133.2023.07.05.03.32.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 03:32:19 -0700 (PDT)
Message-ID: <2b7a0291-dd7d-a6b6-d269-d23d115a76a4@redhat.com>
Date:   Wed, 5 Jul 2023 12:32:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v21 20/20] tests/avocado: s390x cpu topology bad move
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-21-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230630091752.67190-21-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/06/2023 11.17, Pierre Morel wrote:
> This test verifies that QEMU refuses to move a CPU to an
> unexistant location.

s/unexistant/nonexistent/ ?

> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   tests/avocado/s390_topology.py | 25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
> 
> diff --git a/tests/avocado/s390_topology.py b/tests/avocado/s390_topology.py
> index 99d9508cef..ea39168b53 100644
> --- a/tests/avocado/s390_topology.py
> +++ b/tests/avocado/s390_topology.py
> @@ -388,3 +388,28 @@ def test_dedicated_error(self):
>           res = self.vm.qmp('set-cpu-topology',
>                             {'core-id': 0, 'entitlement': 'medium', 'dedicated': False})
>           self.assertEqual(res['return'], {})
> +
> +    def test_move_error(self):
> +        """
> +        This test verifies that QEMU refuses to move a CPU to an
> +        unexistant location

s/unexistant/nonexistent/ ?

With the words fixed:
Reviewed-by: Thomas Huth <thuth@redhat.com>


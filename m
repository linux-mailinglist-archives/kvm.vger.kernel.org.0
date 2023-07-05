Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620BD74821B
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 12:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbjGEK1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 06:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjGEK1b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 06:27:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5702DE63
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 03:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688552800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EFbPNA1JPoApPh83wOpxfN2kwsdBECeboggBXc7fBWU=;
        b=ixPz4NWPbqNgAuphUgPHWwbnMstP5q7NIZCfGxYOEjFddlR8Lh2T/jUCk0GWWrD7mlhEv0
        fuSCxRDXR7W7WIZ0bIXeC500MA39DDJMXAOupYg3BhgJovd981lc8UMBbYOCx8IdP2ZmdU
        L9isPSncmn/QVyeWyMKtS0OJGBdAJh8=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-psF_3GZqP_Olia9Q8U8WfQ-1; Wed, 05 Jul 2023 06:26:39 -0400
X-MC-Unique: psF_3GZqP_Olia9Q8U8WfQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-621257e86daso70408076d6.1
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 03:26:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688552799; x=1691144799;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EFbPNA1JPoApPh83wOpxfN2kwsdBECeboggBXc7fBWU=;
        b=a/M3BrzLtM8zNBYRm/agFny5uq7HA0CTptBisos1TArOH+VM+65waadIl7JQ6mMLBM
         39GA7UiRiY3XOw9NPhpuO+oHtVilyf6tNFcaPC3IbRYnHCiI9w2kHjr6jGlxIjLH93bC
         kvIa0Jnt5yngzkT24LqJMaTq+s/gXajLicHp05Tz/g8QL/wA6u0A4GHN6eZjPe7eQ8/9
         3mis+NNXI+UL99QsMl5+rgXN6wEjoDkSUfmctN0cHfCr/qw9+F7NWZrLoQMgRRLbJRbp
         532wl/VFMPXSJsjKV/RXawg8JTIABlkT3MsEn/gh5JMcPbAAKM+ULRKZ1Z2V8Y+fzgH4
         megA==
X-Gm-Message-State: ABy/qLa9xZqcbw6Yj5r19fJvvzS2/dBtkZH4d0bSpoP9HLLZywr+oK7V
        gc8IxmDknzBKSzTKH3sauf4yiUVL2t1P3mF5BcSfMny7AgeA4ja2AK1nYRz1P3uGEJtMBSu+TfX
        WnV/Vj2IwGK5i
X-Received: by 2002:a05:6214:da9:b0:625:af4b:415a with SMTP id h9-20020a0562140da900b00625af4b415amr24836759qvh.19.1688552798854;
        Wed, 05 Jul 2023 03:26:38 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEDgM8Tt5YKkvYP+0aWuEcIqpWhvUVvSVZXSI+G3YI4DrugO9rCsrR381GmVgW6c9Pk4ozOlQ==
X-Received: by 2002:a05:6214:da9:b0:625:af4b:415a with SMTP id h9-20020a0562140da900b00625af4b415amr24836733qvh.19.1688552798648;
        Wed, 05 Jul 2023 03:26:38 -0700 (PDT)
Received: from [10.33.192.205] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id jy19-20020a0562142b5300b00635e9db359bsm10504628qvb.82.2023.07.05.03.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 03:26:38 -0700 (PDT)
Message-ID: <917541c2-65b6-18b5-cf83-e72bf570eacf@redhat.com>
Date:   Wed, 5 Jul 2023 12:26:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v21 18/20] tests/avocado: s390x cpu topology test socket
 full
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
 <20230630091752.67190-19-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230630091752.67190-19-pmorel@linux.ibm.com>
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
> This test verifies that QMP set-cpu-topology does not accept
> to overload a socket.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   tests/avocado/s390_topology.py | 25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
> 
> diff --git a/tests/avocado/s390_topology.py b/tests/avocado/s390_topology.py
> index cba44bec91..0003b30702 100644
> --- a/tests/avocado/s390_topology.py
> +++ b/tests/avocado/s390_topology.py
> @@ -315,3 +315,28 @@ def test_dedicated(self):
>           self.guest_set_dispatching('0');
>   
>           self.check_topology(0, 0, 0, 0, 'high', True)
> +
> +    def test_socket_full(self):
> +        """
> +        This test verifies that QEMU does not accept to overload a socket.
> +        The socket-id 0 on book-id 0 already contains CPUs 0 and 1 and can
> +        not accept any new CPU while socket-id 0 on book-id 1 is free.
> +
> +        :avocado: tags=arch:s390x
> +        :avocado: tags=machine:s390-ccw-virtio
> +        """
> +        self.kernel_init()
> +        self.vm.add_args('-smp',
> +                         '3,drawers=2,books=2,sockets=3,cores=2,maxcpus=24')
> +        self.vm.launch()
> +        self.wait_until_booted()
> +
> +        self.system_init()
> +
> +        res = self.vm.qmp('set-cpu-topology',
> +                          {'core-id': 2, 'socket-id': 0, 'book-id': 0})
> +        self.assertEqual(res['error']['class'], 'GenericError')
> +
> +        res = self.vm.qmp('set-cpu-topology',
> +                          {'core-id': 2, 'socket-id': 0, 'book-id': 1})
> +        self.assertEqual(res['return'], {})

Reviewed-by: Thomas Huth <thuth@redhat.com>


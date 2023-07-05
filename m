Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5931747EBF
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 09:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbjGEH6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 03:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjGEH6v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 03:58:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD92B133
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 00:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688543893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DHyUUWj6BrRpeBXtGyi+Vo8u/2b6hcAsHGdukza2YEg=;
        b=T/x/BfM8L7QipS11DQx5B6sgg6UOoI1PqYY/Jk5b3OBW9vjBciaoaLrPZftaEpigzj8GPG
        Nrk6aENcQtlSTR5UwxuaD6gsDbetQ794oehGJE03op4sdTUOOGMLAFL/nvnLZVe5IqoMcz
        xsNuIPySMDDlekDtZ2oq65mvQL9t6uM=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-J17wmQpQNT2Kp_7pi3ZGuw-1; Wed, 05 Jul 2023 03:58:09 -0400
X-MC-Unique: J17wmQpQNT2Kp_7pi3ZGuw-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4031d923632so47739991cf.2
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 00:58:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688543889; x=1691135889;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DHyUUWj6BrRpeBXtGyi+Vo8u/2b6hcAsHGdukza2YEg=;
        b=SxYKv4ILXwIMTw2udJLoFloMjOvDfd70HpKKeSSyIAyfHiWtq0wB3RUeMvRCkOeqJE
         34DDCzc8Mi7SdtPrvgQo3UvUCgomhi+qb3dIXDV1tarXqCR50l31eJSkyeSgkGYLcx2+
         SKcGjQMzxI5jw+N4IqXoFDHzXIZu5jbqjIue6WbdxRGOMCeScgyH5FM/GWRWBP/sld1L
         DqkkoUVwSnad+B/2fOaxrReoR52QxrYOyxlgbkuFIYXhu2oAHO2UE6V8SXnwLudX7ldN
         Nuvnb2aIcHmCt/XG8Ghl0ubWvHEN3Z71+szKQD29vijuz6ZY63Mab+j5oZnDPP/tSfts
         9akQ==
X-Gm-Message-State: AC+VfDzIOF/MV803M8h/nbdWJlVgWKN5RIhPazloaQvLPbiMZh5mTzbX
        gvrczxFpO+piE00N71iOkM+Bqbt7nyv3DQ5YZF/laDEIgF56r6PuE+G1MYDiCmyg1NOcYXDXqvA
        tPu+IjQIdUug3
X-Received: by 2002:ac8:7e95:0:b0:400:a9db:f0cb with SMTP id w21-20020ac87e95000000b00400a9dbf0cbmr17119495qtj.12.1688543889322;
        Wed, 05 Jul 2023 00:58:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4VuOMVWA8XBvaJxR0q5M6RwQbAsHqqk0YDI9u2J8ujXYh0h4xbzBgwyDXuEmGGcn2BnoZROQ==
X-Received: by 2002:ac8:7e95:0:b0:400:a9db:f0cb with SMTP id w21-20020ac87e95000000b00400a9dbf0cbmr17119485qtj.12.1688543889007;
        Wed, 05 Jul 2023 00:58:09 -0700 (PDT)
Received: from [10.33.192.205] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id j11-20020ac85f8b000000b003fdec95e9c8sm7613863qta.83.2023.07.05.00.58.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 00:58:08 -0700 (PDT)
Message-ID: <3d4d0349-45c1-28c7-1da1-3c66f03025a0@redhat.com>
Date:   Wed, 5 Jul 2023 09:58:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v21 12/20] qapi/s390x/cpu topology: query-cpu-polarization
 qmp command
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
 <20230630091752.67190-13-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230630091752.67190-13-pmorel@linux.ibm.com>
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
> The query-cpu-polarization qmp command returns the current
> CPU polarization of the machine.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   qapi/machine-target.json | 29 +++++++++++++++++++++++++++++
>   hw/s390x/cpu-topology.c  |  8 ++++++++
>   2 files changed, 37 insertions(+)
> 
> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> index 1362e43983..1e4b8976aa 100644
> --- a/qapi/machine-target.json
> +++ b/qapi/machine-target.json
> @@ -445,3 +445,32 @@
>     'features': [ 'unstable' ],
>     'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>   }
> +
> +##
> +# @CpuPolarizationInfo:
> +#
> +# The result of a cpu polarization
> +#
> +# @polarization: the CPU polarization
> +#
> +# Since: 8.1
> +##
> +{ 'struct': 'CpuPolarizationInfo',
> +  'data': { 'polarization': 'CpuS390Polarization' },
> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
> +}
> +
> +##
> +# @query-cpu-polarization:
> +#
> +# Features:
> +# @unstable: This command may still be modified.
> +#
> +# Returns: the machine polarization
> +#
> +# Since: 8.1
> +##
> +{ 'command': 'query-cpu-polarization', 'returns': 'CpuPolarizationInfo',

Since this is very specific to s390x, I wonder whether we want to have a 
"s390x" in the command name? 'query-s390x-cpu-polarization'? ... or is this 
getting too long already?

Anyway,
Reviewed-by: Thomas Huth <thuth@redhat.com>


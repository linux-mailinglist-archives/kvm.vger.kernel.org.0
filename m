Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFC04FDA64
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 12:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbiDLJ5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 05:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384163AbiDLIjZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 04:39:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7AA6D23BD4
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 01:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649750751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bRz8VjSH1qSjZ4cp0lB46Ds2dFD0SLl2/TdMcFrMbKc=;
        b=hSuUkKNKcLPp29pfqAdwsDE4wlnARHNsBvVskw1T7/ZdOXach9TzyZzng+Y86fgcM83qsY
        64oOZBeoaAwzcRhkgvse+sTmxVygoqqg/mENAtlYy1sJQkDnJN+XJwGUUV/jiHcgf0PhOh
        MdJY0y4BRA5JXwgB29bRR3FjauP3uH8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-BiLTbxgOMl-bjbciYTtcXg-1; Tue, 12 Apr 2022 04:05:50 -0400
X-MC-Unique: BiLTbxgOMl-bjbciYTtcXg-1
Received: by mail-wr1-f72.google.com with SMTP id k20-20020adfc714000000b001e305cd1597so3792645wrg.19
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 01:05:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bRz8VjSH1qSjZ4cp0lB46Ds2dFD0SLl2/TdMcFrMbKc=;
        b=pyBiAEvMCWxO56vxUGQbgvVU/6/KweFoG57u//IFWufug6mSySEgcichBRPR0rbSxP
         a/aXgej39+AewZ6eVzcvB+5/jyRPFhnm/VOEleQeUnrtYAUp5EC25l0bem3/z0IVd3pQ
         rpaxU1h4fkKdcgqhSvcXjTbjlivCjH4FZWxcHXtfZ7vVaIuJjfGSBdvtGoFiAhH/Siwz
         cIk2tjl0VxMNwREzKpWrOxFaKwShSybTOwzXRXZDAKMcQkuJAMQATIuBRKP4LYTbspRs
         fBLa8w0ved3yfjVJplqsa9DwJMrrDInfnJQ8pWozEuNgct18M0MBPJWbxw32mH8kyZRd
         XfLQ==
X-Gm-Message-State: AOAM532yYS/bt4WaNbfvH2miLKAFq1AWp1GlcPa3APtbR410cuRAfjxX
        dhFc9OuVXj6iCIIMTf67ms4KyZ6Hxmxykf8UrpL3h/x4ek7OLEIKpBy/LUUAWdoqmu8fSTahXtX
        wL7iy7ks1PP3+
X-Received: by 2002:adf:dfc2:0:b0:1f0:262a:d831 with SMTP id q2-20020adfdfc2000000b001f0262ad831mr27546412wrn.589.1649750748997;
        Tue, 12 Apr 2022 01:05:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7nqevoJ6F4/MqLgRJopZdu/HIcObXx7C5G8q98MDXMtbREMekakN7wjiTcdoUS6pqVD//3Q==
X-Received: by 2002:adf:dfc2:0:b0:1f0:262a:d831 with SMTP id q2-20020adfdfc2000000b001f0262ad831mr27546396wrn.589.1649750748779;
        Tue, 12 Apr 2022 01:05:48 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id k124-20020a1ca182000000b0038eb706c030sm1679212wme.39.2022.04.12.01.05.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 01:05:48 -0700 (PDT)
Message-ID: <138a93d7-efa4-c2e1-85fc-c041c03ac45f@redhat.com>
Date:   Tue, 12 Apr 2022 10:05:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests PATCH v1 2/4] s390x: add support for migration
 tests
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220411100750.2868587-1-nrb@linux.ibm.com>
 <20220411100750.2868587-3-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220411100750.2868587-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/04/2022 12.07, Nico Boehr wrote:
> Now that we have SCLP console read support, run our tests with migration_cmd, so
> we can get migration support on s390x.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/run | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/run b/s390x/run
> index 064ecd1b337a..2bcdabbaa14f 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -25,7 +25,7 @@ M+=",accel=$ACCEL"
>   command="$qemu -nodefaults -nographic $M"
>   command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
>   command+=" -kernel"
> -command="$(timeout_cmd) $command"
> +command="$(migration_cmd) $(timeout_cmd) $command"
>   
>   # We return the exit code via stdout, not via the QEMU return code
>   run_qemu_status $command "$@"

Reviewed-by: Thomas Huth <thuth@redhat.com>


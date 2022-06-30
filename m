Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1747F56217C
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 19:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbiF3Rtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 13:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235026AbiF3Rtx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 13:49:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE19F20F56
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 10:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656611391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YX1bR12sGvuZbq9kc/Zna9+NJHM/jYjFY2F171r8rlg=;
        b=F214W0VpaivfwYenY1E6Nr3DidOZ7CRqjFATwCWL5qdCaEyKLk6c2z2RfgJslGt6zKormF
        whWNF7VfwF737fkB8k48wQRSvhHs1UIvw3dQIL+M2f5Qjzli8lj5CQRtlodEYS/aBItxf0
        OKwU+7Y8xBNCNr0cYi4+PcnjhC4zjcg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-0OI00ZIEPBWETOzJzWMNcg-1; Thu, 30 Jun 2022 13:49:50 -0400
X-MC-Unique: 0OI00ZIEPBWETOzJzWMNcg-1
Received: by mail-wm1-f70.google.com with SMTP id i184-20020a1c3bc1000000b003a026f48333so8250122wma.4
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 10:49:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=YX1bR12sGvuZbq9kc/Zna9+NJHM/jYjFY2F171r8rlg=;
        b=pWwGMQIlSb7fwtvidpjKQXi1dItaY8QH2bSRoGdwUKeS+nQSZMFv7lVthSth/XyVDg
         +7xjXcx/z9EUCj2CCr42hW9B6PSOZOsMs5NgHKuOjkB63tu11Is6cu4/qOAtv7kYtvdO
         wu0t6+CO52uWKec5rkoCEUqQpyQrKCjqOel1zwCOhyVhCO9lOIYJ2CL3BdeyLhWp8VFD
         m2w13OtAJPsLm5rTZAW87ksdURXR4ZNW1befRBhhRstxsHdAXWNixVTnKAZSXA4ViEgb
         cq6cBq38CHQo3oI3OCBqPj86wTDhJy6aaqirQGAIMzii8LesLgORMN3OvC35d6Muv6Tc
         j+uQ==
X-Gm-Message-State: AJIora/SDMcDd3wUoPeKLgWs7J2SKachC/Y35KdJSbeDoIQ6BC9UlKD0
        Bg1XGJLgKBbQU5aFPxaicCuB26cf+CteKs+UbxZwbLJ+jOsbPlcNsEQSRWDF+cZPlMisBOzdqnn
        +p1C8BFNHWACe
X-Received: by 2002:adf:dd41:0:b0:21b:8201:4b66 with SMTP id u1-20020adfdd41000000b0021b82014b66mr9327803wrm.706.1656611388771;
        Thu, 30 Jun 2022 10:49:48 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uWjW9eRkAyab6fCKtroJUXnnMkhiwou47+TLsOjeMsrON96jn2Br3Na/FWb8Fr3dppv3zjvQ==
X-Received: by 2002:adf:dd41:0:b0:21b:8201:4b66 with SMTP id u1-20020adfdd41000000b0021b82014b66mr9327786wrm.706.1656611388401;
        Thu, 30 Jun 2022 10:49:48 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-179-66.web.vodafone.de. [109.43.179.66])
        by smtp.gmail.com with ESMTPSA id p28-20020a1c545c000000b003a02de5de80sm3400129wmi.4.2022.06.30.10.49.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 10:49:46 -0700 (PDT)
Message-ID: <60f5b2f9-7c97-865c-075b-cb690bdcb082@redhat.com>
Date:   Thu, 30 Jun 2022 19:49:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220630113059.229221-1-nrb@linux.ibm.com>
 <20220630113059.229221-2-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/3] runtime: add support for panic
 tests
In-Reply-To: <20220630113059.229221-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/06/2022 13.30, Nico Boehr wrote:
> QEMU suports a guest state "guest-panicked" which indicates something in

s/suports/supports/

> the guest went wrong, for example on s390x, when an external interrupt
> loop was triggered.
> 
> Since the guest does not continue to run when it is in the
> guest-panicked state, it is currently impossible to write panicking
> tests in kvm-unit-tests. Support from the runtime is needed to check
> that the guest enters the guest-panicked state.
> 
> Similar to migration tests, add a new group panic. Tests in this
> group must enter the guest-panicked state to succeed.
> 
> The runtime will spawn a QEMU instance, connect to the QMP and listen
> for events. To parse the QMP protocol, jq[1] is used. Same as with
> netcat in the migration tests, panic tests won't run if jq is not
> installed.
> 
> The guest is created in the stopped state and only continued when
> connection to the QMP was successful. This ensures no events are missed
> between QEMU start and the connect to the QMP.
> 
> [1] https://stedolan.github.io/jq/
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/run             |  2 +-
>   scripts/arch-run.bash | 47 +++++++++++++++++++++++++++++++++++++++++++
>   scripts/runtime.bash  |  3 +++
>   3 files changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/run b/s390x/run
> index 24138f6803be..f1111dbdbe62 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -30,7 +30,7 @@ M+=",accel=$ACCEL"
>   command="$qemu -nodefaults -nographic $M"
>   command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
>   command+=" -kernel"
> -command="$(migration_cmd) $(timeout_cmd) $command"
> +command="$(panic_cmd) $(migration_cmd) $(timeout_cmd) $command"
>   
>   # We return the exit code via stdout, not via the QEMU return code
>   run_qemu_status $command "$@"
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 0dfaf017db0a..5663a1ddb09e 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -104,6 +104,12 @@ qmp ()
>   	echo '{ "execute": "qmp_capabilities" }{ "execute":' "$2" '}' | ncat -U $1
>   }
>   
> +qmp_events ()
> +{
> +	while ! test -S "$1"; do sleep 0.1; done
> +	echo '{ "execute": "qmp_capabilities" }{ "execute": "cont" }' | ncat --no-shutdown -U $1 | jq -c 'select(has("event"))'

Break the long line into two or three?

> +}
> +
>   run_migration ()
>   {
>   	if ! command -v ncat >/dev/null 2>&1; then
> @@ -164,6 +170,40 @@ run_migration ()
>   	return $ret
>   }
>   
> +run_panic ()
> +{
> +	if ! command -v ncat >/dev/null 2>&1; then
> +		echo "${FUNCNAME[0]} needs ncat (netcat)" >&2
> +		return 77
> +	fi
> +
> +	if ! command -v jq >/dev/null 2>&1; then
> +		echo "${FUNCNAME[0]} needs jq" >&2
> +		return 77
> +	fi
> +
> +	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
> +
> +	trap 'kill 0; exit 2' INT TERM
> +	trap 'rm -f ${qmp}' RETURN EXIT
> +
> +	# start VM stopped so we don't miss any events
> +	eval "$@" -chardev socket,id=mon1,path=${qmp},server=on,wait=off \
> +		-mon chardev=mon1,mode=control -S &
> +
> +	panic_event_count=$(qmp_events ${qmp} | jq -c 'select(.event == "GUEST_PANICKED")' | wc -l)
> +	if [ $panic_event_count -lt 1 ]; then

Maybe put double-quotes around $panic_event_count , just to be sure?

With the nits fixed:

Reviewed-by: Thomas Huth <thuth@redhat.com>


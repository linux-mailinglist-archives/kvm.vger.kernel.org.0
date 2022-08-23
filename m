Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6194259E5BF
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 17:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242609AbiHWPLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 11:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242257AbiHWPKp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 11:10:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96F4144E30
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 03:20:34 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27N8VUEn007251
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 09:40:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=0fsifcepCOh7tvXSeoBuMTz0QJLgjfhFwxMZufEfIcQ=;
 b=evz5oeWzKTn5PjtiFnnMTAWImtBtdKbvaiZhC+SoNwx6EsPJctbSluNvMNdJeedsbz4G
 9At5cTvfmJsbDI88ZNwvCxtDEK8oO4ykj5I8mG6wUTGI+mFadcWuPiyw9JPiNZk40EBU
 mHrLN0398d+M9IcL6WiC5hn1RbFDgxcA5TkUxfVn+PJnUeiBfE0rrEyEZ1ItuNkmZHTs
 rID3hKEHSzVVaZ76h4wyHNkCgRWPjD6H0XyoR/m7IRo2aQhCy8/OCY3iO2Omh+tNKhXc
 5Fdep8gh3z284hFlBPts24lzg+3W2b7tHMMr6gxrYUlLlKxDYkT5r1GqKOb/OLVtGREc eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4uf79xp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 09:40:05 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27N8Vhlb007867
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 09:40:05 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4uf79xmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 09:40:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27N9aJrt027852;
        Tue, 23 Aug 2022 09:40:02 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3j2q88uj2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 09:40:02 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27N9dxko24772912
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 09:39:59 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B8F2A405B;
        Tue, 23 Aug 2022 09:39:59 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 214DAA4054;
        Tue, 23 Aug 2022 09:39:59 +0000 (GMT)
Received: from [9.145.84.26] (unknown [9.145.84.26])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 09:39:59 +0000 (GMT)
Message-ID: <703fbc84-c93e-2d3b-941d-9bf27f421202@linux.ibm.com>
Date:   Tue, 23 Aug 2022 11:39:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v5 1/4] runtime: add support for panic
 tests
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220823084525.52365-1-nrb@linux.ibm.com>
 <20220823084525.52365-2-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220823084525.52365-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: U8NwB5VCtMeE73LZfftN8Xm5pmX3Qwsw
X-Proofpoint-ORIG-GUID: YLDZdLJTAeWMZFeFxh61nSfFPl9yyZa7
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_04,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 malwarescore=0 adultscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/23/22 10:45, Nico Boehr wrote:
> QEMU supports a guest state "guest-panicked" which indicates something
> in the guest went wrong, for example on s390x, when an external

s/,/./

> interrupt loop was triggered.
> 
> Since the guest does not continue to run when it is in the
> guest-panicked state, it is currently impossible to write panicking
> tests in kvm-unit-tests. Support from the runtime is needed to check
> that the guest enters the guest-panicked state.
> 
> Similar to migration tests, add a new group panic. Tests in this

Either:
"panic" group
or
group called "panic"

> group must enter the guest-panicked state to succeed.
> 
> The runtime will spawn a QEMU instance, connect to the QMP and listen
> for events. To parse the QMP protocol, jq[1] is used. Same as with
> netcat in the migration tests, panic tests won't run if jq is not
> installed.
> 
> The guest is created in the stopped state and only continued when

s/continued/is resumed when/

> connection to the QMP was successful. This ensures no events are missed
> between QEMU start and the connect to the QMP.
> 
> [1] https://stedolan.github.io/jq/
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Acked-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   s390x/run             |  2 +-
>   scripts/arch-run.bash | 49 +++++++++++++++++++++++++++++++++++++++++++
>   scripts/runtime.bash  |  3 +++
>   3 files changed, 53 insertions(+), 1 deletion(-)
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
> index 0dfaf017db0a..51e4b97b27d1 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -104,6 +104,14 @@ qmp ()
>   	echo '{ "execute": "qmp_capabilities" }{ "execute":' "$2" '}' | ncat -U $1
>   }
>   
> +qmp_events ()
> +{
> +	while ! test -S "$1"; do sleep 0.1; done
> +	echo '{ "execute": "qmp_capabilities" }{ "execute": "cont" }' |
> +		ncat --no-shutdown -U $1 |
> +		jq -c 'select(has("event"))'
> +}
> +
>   run_migration ()
>   {
>   	if ! command -v ncat >/dev/null 2>&1; then
> @@ -164,6 +172,40 @@ run_migration ()
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
> +	if [ "$panic_event_count" -lt 1 ]; then
> +		echo "FAIL: guest did not panic"
> +		ret=3
> +	else
> +		# some QEMU versions report multiple panic events
> +		echo "PASS: guest panicked"
> +		ret=1
> +	fi
> +
> +	return $ret
> +}
> +
>   migration_cmd ()
>   {
>   	if [ "$MIGRATION" = "yes" ]; then
> @@ -171,6 +213,13 @@ migration_cmd ()
>   	fi
>   }
>   
> +panic_cmd ()
> +{
> +	if [ "$PANIC" = "yes" ]; then
> +		echo "run_panic"
> +	fi
> +}
> +
>   search_qemu_binary ()
>   {
>   	local save_path=$PATH
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index bbf87cf4ed3f..f8794e9a25ce 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -145,6 +145,9 @@ function run()
>       if find_word "migration" "$groups"; then
>           cmdline="MIGRATION=yes $cmdline"
>       fi
> +    if find_word "panic" "$groups"; then
> +        cmdline="PANIC=yes $cmdline"
> +    fi
>       if [ "$verbose" = "yes" ]; then
>           echo $cmdline
>       fi


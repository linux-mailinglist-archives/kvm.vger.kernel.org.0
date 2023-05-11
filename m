Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540F86FEF9F
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 12:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbjEKKGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 06:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjEKKGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 06:06:40 -0400
Received: from out-7.mta0.migadu.com (out-7.mta0.migadu.com [IPv6:2001:41d0:1004:224b::7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4310F868D
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 03:06:38 -0700 (PDT)
Date:   Thu, 11 May 2023 12:06:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683799596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z+aWv3dxKKfyJHceGqTUBu82Oukos+qfj42GrKteHkw=;
        b=fbP2OneWxJAdLLgqM/0NifIWplOCLr6SOegEVER3JHx6j0hrE13Y8rmxOb1xgzSfV8hKhK
        Xbe01UdH5zpKmtvIioYFpGIMn4O5sWuiyABn5/50xn+nGiY04+7yveBioRg2OaVRz9H4Ec
        QVokL9NYzSOTTMqHZiqWuESxo28eCh0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     =?utf-8?B?5Lu75pWP5pWPKOiBlOmAmumbhuWbouiBlOmAmuaVsOWtl+enkeaKgOaciQ==?=
         =?utf-8?B?6ZmQ5YWs5Y+45pys6YOoKQ==?= <renmm6@chinaunicom.cn>
Cc:     kvm <kvm@vger.kernel.org>, pbonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] run_tests: add list tests name option on
 command line
Message-ID: <20230511-c28341edcfad3aea9e7bac0d@orel>
References: <20230511083329.3432954-1-renmm6@chinaunicom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230511083329.3432954-1-renmm6@chinaunicom.cn>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023 at 04:33:29PM +0800, 任敏敏(联通集团联通数字科技有限公司本部) wrote:
> From: rminmin <renmm6@chinaunicom.cn>
> 
> Add '-l | --list' option on command line to output
> all tests name only, and cloud be filtered by group
> with '-g | --group' option.
> 
> E.g.
>   List all vmx group tests name:
>   $ ./run_tests.sh -g vmx -l
> 
>   List all tests name:
>   $ ./run_tests.sh -l
> 
> Signed-off-by: rminmin <renmm6@chinaunicom.cn>
> ---
>  run_tests.sh        | 14 ++++++++++++--
>  scripts/common.bash | 24 ++++++++++++++++++++++++
>  2 files changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index f61e005..a95c2bc 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -15,7 +15,7 @@ function usage()
>  {
>  cat <<EOF
> 
> -Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t]
> +Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t] [-l]
> 
>      -h, --help      Output this help text
>      -v, --verbose   Enables verbose mode
> @@ -24,6 +24,7 @@ Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t]
>      -g, --group     Only execute tests in the given group
>      -j, --parallel  Execute tests in parallel
>      -t, --tap13     Output test results in TAP format
> +    -l, --list      Only output all tests list
> 
>  Set the environment variable QEMU=/path/to/qemu-system-ARCH to
>  specify the appropriate qemu binary for ARCH-run.
> @@ -42,7 +43,8 @@ if [ $? -ne 4 ]; then
>  fi
> 
>  only_tests=""
> -args=$(getopt -u -o ag:htj:v -l all,group:,help,tap13,parallel:,verbose -- $*)
> +list_tests=""
> +args=$(getopt -u -o ag:htj:v:l -l all,group:,help,tap13,parallel:,verbose:,list -- $*)
>  [ $? -ne 0 ] && exit 2;
>  set -- $args;
>  while [ $# -gt 0 ]; do
> @@ -73,6 +75,9 @@ while [ $# -gt 0 ]; do
>          -t | --tap13)
>              tap_output="yes"
>              ;;
> +       -l | --list)
> +           list_tests="yes"
> +           ;;

run_tests.sh is a complete mess for space/tab style, but it looks like
you've used tabs when the rest of this case statement is using spaces...

>          --)
>              ;;
>          *)
> @@ -154,6 +159,11 @@ function run_task()
>  : ${unittest_run_queues:=1}
>  config=$TEST_DIR/unittests.cfg
> 
> +if [[ $list_tests == "yes" ]];then
                                 ^ please add a space here after ;

> +       output_tests_list $config
> +       exit
> +fi
> +
>  rm -rf $unittest_log_dir.old
>  [ -d $unittest_log_dir ] && mv $unittest_log_dir $unittest_log_dir.old
>  mkdir $unittest_log_dir || exit 2
> diff --git a/scripts/common.bash b/scripts/common.bash
> index 7b983f7..7ff1098 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -61,6 +61,30 @@ function arch_cmd()
>         [ "${ARCH_CMD}" ] && echo "${ARCH_CMD}"
>  }
> 
> +function output_tests_list()
> +{
> +       local unittests="$1"
> +       local testname=""
> +       local group=""
> +       exec {fd}<"$unittests"
> +       while read -r -u $fd line; do
> +               if [[ "$line" =~ ^\[(.*)\]$ ]]; then
> +                       if [ -z "${only_group}" ] || [[ -n "${group}" ]];then
> +                               if [ -n "${testname}" ];then
> +                                       echo "${testname}"
> +                               fi
> +                       fi
> +                       testname=${BASH_REMATCH[1]}
> +                       group=""
> +               elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
> +                       local groups=${BASH_REMATCH[1]}
> +                       if [ -n "$only_group" ] && find_word "$only_group" "$groups";then
> +                               group=$only_group
> +                       fi
> +               fi
> +       done
> +}
> +

None of this is necessary. All you need is to add the '--list' option and
then do

diff --git a/run_tests.sh b/run_tests.sh
index f61e0057b537..4c1b174a20bb 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -154,6 +154,12 @@ function run_task()
 : ${unittest_run_queues:=1}
 config=$TEST_DIR/unittests.cfg

+print_testname() { echo "$1"; }
+if [[ $list_tests == "yes" ]]; then
+       for_each_unittest $config print_testname
+       exit
+fi
+
 rm -rf $unittest_log_dir.old
 [ -d $unittest_log_dir ] && mv $unittest_log_dir $unittest_log_dir.old
 mkdir $unittest_log_dir || exit 2


Thanks,
drew

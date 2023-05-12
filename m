Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8DD70044E
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 11:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240492AbjELJyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 05:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240324AbjELJyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 05:54:38 -0400
Received: from out-62.mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBC2E708
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 02:54:28 -0700 (PDT)
Date:   Fri, 12 May 2023 11:54:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683885266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OFZI+jWz/DFEAFVEGWtkdxXN+VlZbRQHZZdNYwc49aU=;
        b=DxDIJ3lJmXl5QUhKQa0wIh5knKuNM0VFtEbFf0y9LSYVGXxVUm+BUVOH5h8pei3ED9J0tl
        pzMPmg18Rxx06C0JL81/4+ywAgD83XTGd5VUo7uDpuahm6TIi/7thg1wn8uzBHKK5LL9xm
        nZO4cZnsYLhkTft0oP2DiItE6btPgaQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     =?utf-8?B?5Lu75pWP5pWPKOiBlOmAmumbhuWbouiBlOmAmuaVsOWtl+enkeaKgOaciQ==?=
         =?utf-8?B?6ZmQ5YWs5Y+45pys6YOoKQ==?= <renmm6@chinaunicom.cn>
Cc:     kvm <kvm@vger.kernel.org>, pbonzini <pbonzini@redhat.com>,
        rmm1985 <rmm1985@163.com>
Subject: Re: [kvm-unit-tests PATCH v3] run_tests: add list tests name option
 on command line
Message-ID: <20230512-cf39b6be9c4e016a69e652aa@orel>
References: <20230512090928.3437244-1-renmm6@chinaunicom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230512090928.3437244-1-renmm6@chinaunicom.cn>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 12, 2023 at 05:09:28PM +0800, 任敏敏(联通集团联通数字科技有限公司本部) wrote:
> From: rminmin <renmm6@chinaunicom.cn>
> 
> Add '-l | --list' option on command line to output
> all tests name only, and could be filtered by group
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
>  run_tests.sh | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index f61e005..baf8e46 100755
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
> +        -l | --list)
> +            list_tests="yes"
> +            ;;
>          --)
>              ;;
>          *)
> @@ -154,6 +159,20 @@ function run_task()
>  : ${unittest_run_queues:=1}
>  config=$TEST_DIR/unittests.cfg
> 
> +print_testname()
> +{
> +    local testname=$1
> +    local groups=$2
> +    if [ -n "$only_group" ] && ! find_word "$only_group" "$groups"; then
> +        return
> +    fi
> +    echo "$testname"
> +}
> +if [[ $list_tests == "yes" ]]; then
> +    for_each_unittest $config print_testname
> +    exit
> +fi
> +
>  rm -rf $unittest_log_dir.old
>  [ -d $unittest_log_dir ] && mv $unittest_log_dir $unittest_log_dir.old
>  mkdir $unittest_log_dir || exit 2
> --
> 2.33.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

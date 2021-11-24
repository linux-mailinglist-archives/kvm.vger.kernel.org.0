Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2C645CA61
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 17:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349228AbhKXQwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 11:52:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59315 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238391AbhKXQwO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Nov 2021 11:52:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637772544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9J3cD1dyyOWaeZtyt11eMPdAt6Sv3JFpKNvzxQVuJ5s=;
        b=IG1v0nQQ71sc2GQHzZi6kEub+J0nR4Fc+EPw1IHe5OzG5WKqUhGhxHg413X6/fM9xQt0Om
        MvVEsj4psB00ExqBxAC2BzBapngruABkQ+ABcPe+AOnYH9v/cAfmdhyoruEZGalh5b9Bui
        6gAtrskFHYvXkEXHsw38WLixVFunOuM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-oj64JkBmNlyV-ePbyib8lQ-1; Wed, 24 Nov 2021 11:49:03 -0500
X-MC-Unique: oj64JkBmNlyV-ePbyib8lQ-1
Received: by mail-wm1-f70.google.com with SMTP id m14-20020a05600c3b0e00b0033308dcc933so1753345wms.7
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 08:49:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9J3cD1dyyOWaeZtyt11eMPdAt6Sv3JFpKNvzxQVuJ5s=;
        b=agG4P8y+1ywKdEPe6UdPyeYKNNjOmFOGOP+SiiRhzGlmah/hvt1Ua4LZNZZr8o6N0y
         yRBu34v0qCNhZcAZ+MWJ7e5SYZpmCd0HttUwbK5B/rkOGxJBAJQu3zwUiOI0zQKD0wq1
         xROpg+XLKGqot8D/DZ0Ye6JZXKot5xTOk9e0OUx9dsWt4+ELU1wrTPookuluZodzV2OI
         Cp2DZzx406y2Kq8oc5WUzxYbkS3j3URUUw/PxlSLJBabf8ArS+ALn3kHi0+FxLQx8Hmz
         lvJQOutOFHjg0nFjwtBXx2fAC6HD1sLT0tFHdguM323tyySAOshafb//orL2fmKNqqdG
         lj5g==
X-Gm-Message-State: AOAM533mNyhk/d8UDoKpAoWi+HR48OXCrenf5gPoVhuGHj8efqIbHRtN
        3O7FpGNPzENfM6bR3uIVJSh/uCc/xPJsdT4ZYqNhEhtE1E1bcGuPt+0vR7l25LIBl1hhDxINXll
        6yjZLaBT8nKKR
X-Received: by 2002:a05:600c:202:: with SMTP id 2mr17343010wmi.134.1637772541888;
        Wed, 24 Nov 2021 08:49:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz8+y4uHEYO0F0AY23C+bnwKrPr+F3pwAPTFQD3xgmryE/REWkJq9qNVUDwYJm7a9a1iDU8BA==
X-Received: by 2002:a05:600c:202:: with SMTP id 2mr17342972wmi.134.1637772541675;
        Wed, 24 Nov 2021 08:49:01 -0800 (PST)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id o4sm6354481wmq.31.2021.11.24.08.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 08:49:01 -0800 (PST)
Date:   Wed, 24 Nov 2021 17:48:59 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, maz@kernel.org, qemu-arm@nongnu.org,
        idan.horowitz@gmail.com, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [kvm-unit-tests PATCH v8 04/10] run_tests.sh: add --config
 option for alt test set
Message-ID: <20211124164859.4enqimrptr3pfdkp@gator>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
 <20211118184650.661575-5-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211118184650.661575-5-alex.bennee@linaro.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021 at 06:46:44PM +0000, Alex Bennée wrote:
> The upcoming MTTCG tests don't need to be run for normal KVM unit
> tests so lets add the facility to have a custom set of tests.

I think an environment variable override would be better than this command
line override, because then we could also get mkstandalone to work with
the new unittests.cfg files. Or, it may be better to just add them to
the main unittests.cfg with lines like these

groups = nodefault mttcg
accel = tcg

That'll "dirty" the logs with SKIP ... (test marked as manual run only)
for each one, but at least we won't easily forget about running them from
time to time.

Thanks,
drew


> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  run_tests.sh | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index 9f233c5..b1088d2 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -15,7 +15,7 @@ function usage()
>  {
>  cat <<EOF
>  
> -Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t]
> +Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t] [-c CONFIG]
>  
>      -h, --help      Output this help text
>      -v, --verbose   Enables verbose mode
> @@ -24,6 +24,7 @@ Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t]
>      -g, --group     Only execute tests in the given group
>      -j, --parallel  Execute tests in parallel
>      -t, --tap13     Output test results in TAP format
> +    -c, --config    Override default unittests.cfg
>  
>  Set the environment variable QEMU=/path/to/qemu-system-ARCH to
>  specify the appropriate qemu binary for ARCH-run.
> @@ -42,7 +43,7 @@ if [ $? -ne 4 ]; then
>  fi
>  
>  only_tests=""
> -args=$(getopt -u -o ag:htj:v -l all,group:,help,tap13,parallel:,verbose -- $*)
> +args=$(getopt -u -o ag:htj:vc: -l all,group:,help,tap13,parallel:,verbose,config: -- $*)
>  [ $? -ne 0 ] && exit 2;
>  set -- $args;
>  while [ $# -gt 0 ]; do
> @@ -73,6 +74,10 @@ while [ $# -gt 0 ]; do
>          -t | --tap13)
>              tap_output="yes"
>              ;;
> +        -c | --config)
> +            shift
> +            config=$1
> +            ;;
>          --)
>              ;;
>          *)
> @@ -152,7 +157,7 @@ function run_task()
>  
>  : ${unittest_log_dir:=logs}
>  : ${unittest_run_queues:=1}
> -config=$TEST_DIR/unittests.cfg
> +: ${config:=$TEST_DIR/unittests.cfg}
>  
>  rm -rf $unittest_log_dir.old
>  [ -d $unittest_log_dir ] && mv $unittest_log_dir $unittest_log_dir.old
> -- 
> 2.30.2
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm


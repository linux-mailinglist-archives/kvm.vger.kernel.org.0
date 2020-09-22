Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4A0274B89
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 23:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgIVVvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 17:51:32 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:49376 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726179AbgIVVvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Sep 2020 17:51:32 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 2EE755754D;
        Tue, 22 Sep 2020 21:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1600811489;
         x=1602625890; bh=82p0Q+sPgZYU29FlwkYQadDom/Zy5P6AQgqoBBuCogI=; b=
        eUpgFrLYhfMeUV+ZlO7oiZiPFwfel46b5A8tix7u5cHuovx6zeLArrYDAgnMTwol
        YrF00qB17tevbsJigRw6lxgQuIPy8LKf3lApCeH9DXkwIi4PK2R1a7c93gqliZ9m
        ieQokMpPzqHDE5IY8OUiFyLr5s+RIMW5tAsJDJGCL60=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oft2fVIsO0KF; Wed, 23 Sep 2020 00:51:29 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 1A5C257549;
        Wed, 23 Sep 2020 00:51:29 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 23
 Sep 2020 00:51:28 +0300
Date:   Wed, 23 Sep 2020 00:51:28 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        Cameron Esfahani <dirty@apple.com>
Subject: Re: [kvm-unit-tests PATCH v2 06/10] configure: Add an option to
 specify getopt
Message-ID: <20200922215128.GB11460@SPB-NB-133.local>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
 <20200901085056.33391-7-r.bolshakov@yadro.com>
 <922fee6f-f6d0-b6cd-c9b7-63ad5e3a004c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <922fee6f-f6d0-b6cd-c9b7-63ad5e3a004c@redhat.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 22, 2020 at 03:53:27PM +0200, Paolo Bonzini wrote:
> On 01/09/20 10:50, Roman Bolshakov wrote:
> > macOS is shipped with an old non-enhanced version of getopt and it
> > doesn't support options used by run_tests.sh. Proper version of getopt
> > is available from homebrew but it has to be added to PATH before invoking
> > run_tests.sh. It's not convenient because it has to be done in each
> > shell instance and there could be many if a multiplexor is used.
> > 
> > The change provides a way to override getopt and halts ./configure if
> > enhanced getopt can't be found.
> > 
> > Cc: Cameron Esfahani <dirty@apple.com>
> > Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> 
> I don't like the extra option very much, generally people are just expected
> to stick homebrew in their path somehow.  Reporting a better error is a
> good idea though, what about this:
> 

Homebrew doesn't shadow system tools unlike macports. That's why the
patch is helpful and the error below can be corrected automatically
without human intervention. The error in the proposed below patch would
still cause frustrating:

  "ugh. I again forgot to set PATH for this tmux window..."

May be I'm exaggarating the issue, but I don't set PATH on a per-project
basis unless I'm doing something extremely rare or something weird :)

The original patch also shouldn't have an impact on most modern Linux
systems. It would help only a few who build kvm-unit-tests on mac.
Hopefully, it eases contribution and testing of QEMU without an access
to Linux box.

Thanks,
Roman

> diff --git a/configure b/configure
> index 4eb504f..3293634 100755
> --- a/configure
> +++ b/configure
> @@ -167,6 +167,13 @@ EOF
>    rm -f lib-test.{o,S}
>  fi
>  
> +# require enhanced getopt
> +getopt -T > /dev/null
> +if [ $? -ne 4 ]; then
> +    echo "Enhanced getopt is not available, add it to your PATH?"
> +    exit 1
> +fi
> +
>  # Are we in a separate build tree? If so, link the Makefile
>  # and shared stuff so that 'make' and run_tests.sh work.
>  if test ! -e Makefile; then
> diff --git a/run_tests.sh b/run_tests.sh
> index 01e36dc..70d012c 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -34,6 +34,13 @@ EOF
>  RUNTIME_arch_run="./$TEST_DIR/run"
>  source scripts/runtime.bash
>  
> +# require enhanced getopt
> +getopt -T > /dev/null
> +if [ $? -ne 4 ]; then
> +    echo "Enhanced getopt is not available, add it to your PATH?"
> +    exit 1
> +fi
> +
>  only_tests=""
>  args=`getopt -u -o ag:htj:v -l all,group:,help,tap13,parallel:,verbose -- $*`
>  [ $? -ne 0 ] && exit 2;
> 
> Paolo
> 

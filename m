Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BF52554EB
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 09:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgH1HMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 03:12:41 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:36892 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725858AbgH1HMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 03:12:40 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 2774357516;
        Fri, 28 Aug 2020 07:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1598598757;
         x=1600413158; bh=VQgTll1LKDY0usmNA2YOabLuAiRj3JWOLQvTwuQZbc0=; b=
        ULYEMeeQsHqJCKei816R48x2HME986PT0xxswqc4uZnv6VBjP1Drr/E9LySZdZxb
        /SaXnJE2N7p1OCqWrvHRXAAbESsWWegpFm2B7An1ZAAn8fMM/lpza4A7mGGX8ban
        KMfpKvoX8JWiakhZJnyIpQ4hvSxnviEXoymGjAbMpA0=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZB3QntHb7JDP; Fri, 28 Aug 2020 10:12:37 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8B55F574FE;
        Fri, 28 Aug 2020 10:12:37 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 28
 Aug 2020 10:12:37 +0300
Date:   Fri, 28 Aug 2020 10:12:36 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Thomas Huth <thuth@redhat.com>
CC:     <kvm@vger.kernel.org>, Cameron Esfahani <dirty@apple.com>
Subject: Re: [kvm-unit-tests PATCH 6/7] configure: Add an option to specify
 getopt
Message-ID: <20200828071236.GB54274@SPB-NB-133.local>
References: <20200810130618.16066-1-r.bolshakov@yadro.com>
 <20200810130618.16066-7-r.bolshakov@yadro.com>
 <ebccbbb2-dc9b-9ff4-c89c-8fdd6f463a50@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ebccbbb2-dc9b-9ff4-c89c-8fdd6f463a50@redhat.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 28, 2020 at 07:55:53AM +0200, Thomas Huth wrote:
> On 10/08/2020 15.06, Roman Bolshakov wrote:
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
> > ---
> >  configure    | 13 +++++++++++++
> >  run_tests.sh |  2 +-
> >  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> Is this still required with a newer version of bash? The one that ships
> with macOS is just too old...
> 
> I assume that getopt is a builtin function in newer versions of the bash?
> 

Except it has `s` at the end. There's a getopts built-in in bash.
I'll try to replace external getopt with getopts.

> Last time we discussed, we agreed that Bash v4.2 would be a reasonable
> minimum for the kvm-unit-tests:
> 
>  https://www.spinics.net/lists/kvm/msg222139.html
> 
> Thus if the user installed bash from homebrew on macos, we should be fine?
> 
> Could you maybe replace this patch with a check for a minimum version of
> bash instead?
> 

No problem, if getopts works.

Thanks,
Roman

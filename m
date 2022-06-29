Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4B955F5DF
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 07:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiF2F4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 01:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiF2F4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 01:56:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6C4517584
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 22:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656482197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N/v+9oqZL6WilYvlMCahbyFXcdP82Vb1xPe5KfLXVJ8=;
        b=V2zlpc/c19OGXTInwxuweWXLDgnWZNv68z8+M2cWmVhoLU6UtapYi615Y3yV5vY3lDHBLh
        AgQV7s9YbciIqUeubs/k+LyImvn5eiFyofzgrz/dHydQGIRg4FgUZI5SE2w5Z9hRZrORqQ
        fiM55r6JRm+f/9i+Hzrc6iyR+R4Wu7Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-gVf0y3FfMc2pVMuE6QnAqA-1; Wed, 29 Jun 2022 01:56:34 -0400
X-MC-Unique: gVf0y3FfMc2pVMuE6QnAqA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF8C03C1104C;
        Wed, 29 Jun 2022 05:56:33 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.195.112])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 919E81121314;
        Wed, 29 Jun 2022 05:56:33 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 21C5A21E690D; Wed, 29 Jun 2022 07:56:32 +0200 (CEST)
From:   Markus Armbruster <armbru@redhat.com>
To:     jianchunfu <jianchunfu@cmss.chinamobile.com>
Cc:     clg@kaod.org, danielhb413@gmail.com, david@gibson.dropbear.id.au,
        groug@kaod.org, pbonzini@redhat.com, qemu-ppc@nongnu.org,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH] target/ppc: Add error reporting when opening file fails
References: <20220629031552.5407-1-jianchunfu@cmss.chinamobile.com>
Date:   Wed, 29 Jun 2022 07:56:32 +0200
In-Reply-To: <20220629031552.5407-1-jianchunfu@cmss.chinamobile.com>
        (jianchunfu@cmss.chinamobile.com's message of "Wed, 29 Jun 2022
        11:15:52 +0800")
Message-ID: <87a69wrp0v.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

jianchunfu <jianchunfu@cmss.chinamobile.com> writes:

> Add error reporting before return when opening file fails.
>
> Signed-off-by: jianchunfu <jianchunfu@cmss.chinamobile.com>
> ---
>  target/ppc/kvm.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index dc93b99189..ef9a871411 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -1798,6 +1798,7 @@ static int read_cpuinfo(const char *field, char *value, int len)
>  
   static int read_cpuinfo(const char *field, char *value, int len)
   {
       FILE *f;
       int ret = -1;
       int field_len = strlen(field);
       char line[512];

>      f = fopen("/proc/cpuinfo", "r");
>      if (!f) {
> +        fprintf(stderr, "Error opening /proc/cpuinfo: %s\n", strerror(errno));
>          return -1;
>      }

       do {
           if (!fgets(line, sizeof(line), f)) {
               break;
           }
           if (!strncmp(line, field, field_len)) {
               pstrcpy(value, len, line);
               ret = 0;
               break;
           }
       } while (*line);

       fclose(f);

       return ret;
   }

This function now reports an error on one out of two failures.  The
caller can't tell whether it reported or not.

Please use error_report() for errors, warn_report() for warnings, and
info_report() for informational messages.

But is it an error?  Here's the only caller:

    static uint32_t kvmppc_get_tbfreq_procfs(void)
    {
        char line[512];
        char *ns;
        uint32_t tbfreq_fallback = NANOSECONDS_PER_SECOND;
        uint32_t tbfreq_procfs;

        if (read_cpuinfo("timebase", line, sizeof(line))) {
--->        return tbfreq_fallback;
        }

        ns = strchr(line, ':');
        if (!ns) {
--->        return tbfreq_fallback;
        }

        tbfreq_procfs = atoi(++ns);

        /* 0 is certainly not acceptable by the guest, return fallback value */
--->    return tbfreq_procfs ? tbfreq_procfs : tbfreq_fallback;
    }

I marked the three spots that handle errors.  All quietly return
NANOSECONDS_PER_SECOND.  The caller can't tell whether that happened.

Reporting an error when we don't actually fail is confusing.  Better
would be something like "Can't open /proc/cpuinfo, assuming timebase X",
where X is the value you assume.

Reporting this only in one out of several cases where we assume feels
wrong.  If it's worth reporting in one case, why isn't it worth
reporting in the other cases?  Is it worth reporting?

Aside: the use of atoi() silently maps a timebase of 0 to
NANOSECONDS_PER_SECOND.  Not fond of this function.  Not your patch's
problem, of course.

>  
> @@ -1906,6 +1907,7 @@ static uint64_t kvmppc_read_int_dt(const char *filename)
>  
>      f = fopen(filename, "rb");
>      if (!f) {
> +        fprintf(stderr, "Error opening %s: %s\n", filename, strerror(errno));
>          return -1;
>      }

Preexisting: this function returns -1 when fopen() fails, 0 when fread()
fails or read less data than expected.  Its caller
kvmppc_read_int_cpu_dt() passes on the return value.  However, it is
documented to return "0 if anything goes wrong".  Bug.  Not your patch's
fault, but it needs fixing.

Similar issue as above: you make the function emit an error message on
some, but not all failures.  If it's worth reporting in one case, why
isn't it worth reporting in the other cases?  Is it worth reporting?


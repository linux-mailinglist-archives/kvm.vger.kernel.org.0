Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B993074B17E
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 15:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbjGGNKv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 09:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjGGNKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 09:10:49 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EAB561FC9
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 06:10:46 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66FA4D75;
        Fri,  7 Jul 2023 06:11:28 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8DD03F73F;
        Fri,  7 Jul 2023 06:10:44 -0700 (PDT)
Date:   Fri, 7 Jul 2023 14:10:41 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Suzuki.Poulose@arm.com, andre.przywara@arm.com, maz@kernel.org,
        oliver.upton@linux.dev, jean-philippe.brucker@arm.com,
        apatel@ventanamicro.com, kvm@vger.kernel.org
Subject: Re: [PATCH RESEND kvmtool 1/4] util: Make pr_err() return void
Message-ID: <ZKgO0csN08fA_MA3@monolith.localdoman>
References: <20230630133134.65284-1-alexandru.elisei@arm.com>
 <20230630133134.65284-2-alexandru.elisei@arm.com>
 <20230704093717.GB3214657@myrica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230704093717.GB3214657@myrica>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean-Philippe,

On Tue, Jul 04, 2023 at 10:37:17AM +0100, Jean-Philippe Brucker wrote:
> On Fri, Jun 30, 2023 at 02:31:31PM +0100, Alexandru Elisei wrote:
> > Of all the pr_* functions, pr_err() is the only function that returns a
> > value, which is -1. The code in parse_options is the only code that relies
> > on pr_err() returning a value, and that value must be exactly -1, because
> > it is being treated differently than the other return values.
> > 
> > This makes the code opaque, because it's not immediately obvious where that
> > value comes from, and fragile, as a change in the return value of pr_err
> > would break it.
> > 
> > Make pr_err() more like the other functions and don't return a value.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> One small nit below, otherwise 
> 
> Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

Thank you for the review!

> 
> > ---
> >  include/kvm/util.h   |  2 +-
> >  util/parse-options.c | 28 ++++++++++++++++------------
> >  util/util.c          |  3 +--
> >  3 files changed, 18 insertions(+), 15 deletions(-)
> > 
> > diff --git a/include/kvm/util.h b/include/kvm/util.h
> > index b49454876a83..f51f370d2b37 100644
> > --- a/include/kvm/util.h
> > +++ b/include/kvm/util.h
> > @@ -39,7 +39,7 @@ extern bool do_debug_print;
> >  
> >  extern void die(const char *err, ...) NORETURN __attribute__((format (printf, 1, 2)));
> >  extern void die_perror(const char *s) NORETURN;
> > -extern int pr_err(const char *err, ...) __attribute__((format (printf, 1, 2)));
> > +extern void pr_err(const char *err, ...) __attribute__((format (printf, 1, 2)));
> >  extern void pr_warning(const char *err, ...) __attribute__((format (printf, 1, 2)));
> >  extern void pr_info(const char *err, ...) __attribute__((format (printf, 1, 2)));
> >  extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
> > diff --git a/util/parse-options.c b/util/parse-options.c
> > index 9a1bbee6c271..fb44b48d14c8 100644
> > --- a/util/parse-options.c
> > +++ b/util/parse-options.c
> > @@ -17,10 +17,13 @@
> >  static int opterror(const struct option *opt, const char *reason, int flags)
> >  {
> >  	if (flags & OPT_SHORT)
> > -		return pr_err("switch `%c' %s", opt->short_name, reason);
> > -	if (flags & OPT_UNSET)
> > -		return pr_err("option `no-%s' %s", opt->long_name, reason);
> > -	return pr_err("option `%s' %s", opt->long_name, reason);
> > +		pr_err("switch `%c' %s", opt->short_name, reason);
> > +	else if (flags & OPT_UNSET)
> > +		pr_err("option `no-%s' %s", opt->long_name, reason);
> > +	else
> > +		pr_err("option `%s' %s", opt->long_name, reason);
> > +
> > +	return -1;
> >  }
> >  
> >  static int get_arg(struct parse_opt_ctx_t *p, const struct option *opt,
> > @@ -429,14 +432,15 @@ is_abbreviated:
> >  		return get_value(p, options, flags);
> >  	}
> >  
> > -	if (ambiguous_option)
> > -		return pr_err("Ambiguous option: %s "
> > -				"(could be --%s%s or --%s%s)",
> > -				arg,
> > -				(ambiguous_flags & OPT_UNSET) ?  "no-" : "",
> > -				ambiguous_option->long_name,
> > -				(abbrev_flags & OPT_UNSET) ?  "no-" : "",
> > -				abbrev_option->long_name);
> > +	if (ambiguous_option) {
> > +		pr_err("Ambiguous option: %s " "(could be --%s%s or --%s%s)",
> 
> drop " "

Done.

Thanks,
Alex

> 
> > +			arg,
> > +			(ambiguous_flags & OPT_UNSET) ?  "no-" : "",
> > +			ambiguous_option->long_name,
> > +			(abbrev_flags & OPT_UNSET) ?  "no-" : "",
> > +			abbrev_option->long_name);
> > +		return -1;
> > +	}
> >  	if (abbrev_option)
> >  		return get_value(p, abbrev_option, abbrev_flags);
> >  	return -2;
> > diff --git a/util/util.c b/util/util.c
> > index 1877105e3c08..f59f26e1581c 100644
> > --- a/util/util.c
> > +++ b/util/util.c
> > @@ -47,14 +47,13 @@ void die(const char *err, ...)
> >  	va_end(params);
> >  }
> >  
> > -int pr_err(const char *err, ...)
> > +void pr_err(const char *err, ...)
> >  {
> >  	va_list params;
> >  
> >  	va_start(params, err);
> >  	error_builtin(err, params);
> >  	va_end(params);
> > -	return -1;
> >  }
> >  
> >  void pr_warning(const char *warn, ...)
> > -- 
> > 2.41.0
> > 

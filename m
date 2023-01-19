Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCAB6674060
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 18:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjASR57 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 12:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjASR5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 12:57:52 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869ED17CF8
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 09:57:50 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id y3-20020a17090a390300b00229add7bb36so2509205pjb.4
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 09:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r8aYoDmltXLbRoCz5eT2EBAIjNTk9SulTPllobkzS+k=;
        b=Q/55GaFp4D/gbOLaYXVSe0uDiVHsKH9a0Itn+XPdZsMFSJ/FJWMZhd0/XKcOnpTP8G
         ZZ3aOWN59ZwBf/RRp6qP8PvMXZjnP7nLndZV9t60k/H2HwDm2AcS8srOKMK/Q3ws90m5
         PICNWO0Q0og1UaksFRqs20Azr705/8Nq1hcWyb17wxu+fVRUHSJ349h/PttO79QHaO3t
         +H2Qzkl6YkVHRaP7KWYQfpN2TAaehOG4B93xrtpApe+cgh9II9WuWCM+UNajWKqyFdTR
         zUrbBHiJFIzNaUxL9RqpIeeBRoPKxousG9rE5TRbNVKilVN0+jxQ0CXy3B8JPCQJT5S+
         6eGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r8aYoDmltXLbRoCz5eT2EBAIjNTk9SulTPllobkzS+k=;
        b=w9N/BJg2jG1j+NIblAODwS/BZVK/j2x38Zt/00vspM8SzjMA0PVLlRUqlAcAc+JLGI
         VgwygTq/ZhAO8gjZiH8SNzE1cOE7vF+lCf1KbnILw+gbPXDU4Qpf6QmHoHSrUClcJt8I
         0O6F66HIOvfeLLa4BSX401cbnUNWOTa+v/OCaJKIRAYyb8NG1yWAp9q9vyX8mKkuDQwa
         GHCdzp8+lnLIPzE96UsyQWmy636BMq4K5MHU3429CT6dJrBATfksUm2Cygpl5NQIiijw
         we1uF4DKWmgJDgdboU5rTdH7wJodUVqZQI0PrfTFrj4i6TsDH7zhHjvhALNx2RuyNpkf
         E3gQ==
X-Gm-Message-State: AFqh2kp/ZwNHALa0YgALg6GnHC6+dkI9zr14/ohUrZr9ay0PFewQWOFt
        0aUKaWb0j2y5PWsCU2do2GIESA==
X-Google-Smtp-Source: AMrXdXvnTDzt0Vs4kgyKV1HQwpIBTqlhBm3VzrjI31Htrkmf1EpVjtQMrtTTCLcqnrVNTOKxfiac9A==
X-Received: by 2002:a17:90a:d148:b0:229:1e87:365f with SMTP id t8-20020a17090ad14800b002291e87365fmr2372302pjw.2.1674151069870;
        Thu, 19 Jan 2023 09:57:49 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j3-20020a17090a318300b002296094b9cdsm3340526pjb.24.2023.01.19.09.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 09:57:49 -0800 (PST)
Date:   Thu, 19 Jan 2023 17:57:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH] KVM: x86: fix deadlock for KVM_XEN_EVTCHN_RESET
Message-ID: <Y8mEmSESlcdgtVg4@google.com>
References: <20221228110410.1682852-1-pbonzini@redhat.com>
 <20230119155800.fiypvvzoalnfavse@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119155800.fiypvvzoalnfavse@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023, Yu Zhang wrote:
> Hi Paolo,
> 
> > diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
> > index 721f6a693799..dae510c263b4 100644
> > --- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
> > @@ -962,6 +962,12 @@ int main(int argc, char *argv[])
> >  	}
> >  
> >   done:
> > +	struct kvm_xen_hvm_attr evt_reset = {
> > +		.type = KVM_XEN_ATTR_TYPE_EVTCHN,
> > +		.u.evtchn.flags = KVM_XEN_EVTCHN_RESET,
> > +	};
> > +	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &evt_reset);
> > +
> >  	alarm(0);
> >  	clock_gettime(CLOCK_REALTIME, &max_ts);
> >  
> 
> This change generates a build failure with error message: 
> "error: a label can only be part of a statement and a declaration is not a statement".

And other flavors too, e.g.

x86_64/xen_shinfo_test.c:965:2: error: expected expression
        struct kvm_xen_hvm_attr evt_reset = {
        ^
x86_64/xen_shinfo_test.c:969:38: error: use of undeclared identifier 'evt_reset'
        vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &evt_reset);
                                            ^
x86_64/xen_shinfo_test.c:969:38: error: use of undeclared identifier 'evt_reset'
3 errors generated.
make: *** [../lib.mk:145: tools/testing/selftests/kvm/x86_64/xen_shinfo_test] Error 1
make: *** Waiting for unfinished jobs....

I'm surprised bots haven't complained about this, haven't seen any reports.

> Moving the definition of evt_reset to the beginning of main() can fix it:

I'll queue a patch, this is already in Linus' tree and I've collected a few other
tiny fixes for v6.2-rcwhatever that I'll send to Paolo.

Thanks!

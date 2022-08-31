Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966D35A8347
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 18:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbiHaQde (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 12:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiHaQdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 12:33:32 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB695D631E
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:33:31 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id x80so10364502pgx.0
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=29U72hGQYeFyxt0w+ZEB9ou7cUjIaml6fHt3pWCMzLI=;
        b=ZPulCCE7mV+WMgFmd6yS/Ka0mBoHEKqL3zKrBJhc6fRwrNnfpozM/xOFKTIYCBUoHt
         fo29M6ZvzeMdd8pdiGnw2EZAMnudgwPbhj1efSErGDFmbCTc896yfovW8hBF9NL2KLTE
         waXpdkTGDeflf4jCgJL5Ck4VYAHcivAercpIz4wHaIGQyy9IbBBP8L9IM5S9l9kn/REL
         tjHhdjrpZcPxVpE7XDnfAHGr529YLjs5ZVxk1Aph9EVwaBVtisgcecdJFAgjZBFUn/y3
         BHPSAdsGVzHf0s5QW9MRTIzCMJjXU2oO3PFX0mtGt5ZnYJeIjGn41yv5s9j+VdTgAyNT
         ORcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=29U72hGQYeFyxt0w+ZEB9ou7cUjIaml6fHt3pWCMzLI=;
        b=JX//nvosTDQ2cUR2GVNgpgYkisdmDu1TPuN1qT42Mvl64ge4RRC8kaGQgXhMpaIsnX
         PKwMvU4AAJUvyEH2RmaS7UooU3HtawuXwnGg0rdrGH0go/RVgYSwCtvaNll6F3/pF9xg
         5Xy4mXVD6CZqB13EPIksxozfb/0SaOgqUDTzrfFM/NYOlCSz93ogJ8I+pCmNXdtfiiAH
         8N6hWb1AH59w2ovkhtwJYc5Tjc7TXg00mhZWiFEVEfjEBjbEO+LXd0q3kLmDcqWjsfre
         4Po00dRMdj6yO6tmIpKh58anTAydX47DJ0LESJSX/lCiapsITvLFyH05cRVSqQrRvX4p
         f9Vg==
X-Gm-Message-State: ACgBeo0rq/aFxxMA6AqvskFgZuRpHcdVhnNHZgUgRbeyBALkktbvrzjg
        gJjxcpnalQGNglhWgGWAdiJ7gQ==
X-Google-Smtp-Source: AA6agR5G25GeXkw79SWkEjAhnm9hA/Jakg7YTdUbUrWUaqoeJN0f6JmvVS7hBu5On3n9Ue5aIFBLHA==
X-Received: by 2002:a62:e217:0:b0:538:604:2dd0 with SMTP id a23-20020a62e217000000b0053806042dd0mr20095344pfi.70.1661963611112;
        Wed, 31 Aug 2022 09:33:31 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n11-20020a17090a394b00b001fb18855440sm1511160pjf.31.2022.08.31.09.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 09:33:30 -0700 (PDT)
Date:   Wed, 31 Aug 2022 16:33:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH 02/19] KVM: SVM: Don't put/load AVIC when setting virtual
 APIC mode
Message-ID: <Yw+NV3q8D3D2AYrA@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
 <20220831003506.4117148-3-seanjc@google.com>
 <d3a9ab2033b8dedbb0c7cb683e724ee4210bb703.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3a9ab2033b8dedbb0c7cb683e724ee4210bb703.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> > @@ -1118,6 +1107,16 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
> >  		avic_deactivate_vmcb(svm);
> >  	}
> >  	vmcb_mark_dirty(vmcb, VMCB_AVIC);
> > +}
> > +
> > +void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
> > +{
> > +	bool activated = kvm_vcpu_apicv_active(vcpu);
> > +
> > +	if (!enable_apicv)
> > +		return;
> > +
> > +	avic_set_virtual_apic_mode(vcpu);
> 
> This call is misleading - this will usually be called
> when avic mode didn't change - I think we need a better name for
> avic_set_virtual_apic_mode.

I don't disagree, but I'm having trouble coming up with a succinct alternative.
The helper primarily configures the VMCB, but the call to
avic_apicv_post_state_restore() makes avic_refresh_vmcb_controls() undesirable.

Maybe avic_refresh_virtual_apic_mode()?

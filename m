Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31BA0666963
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 04:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbjALDJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 22:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236019AbjALDI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 22:08:59 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453F449149;
        Wed, 11 Jan 2023 19:08:58 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id d10so11863860pgm.13;
        Wed, 11 Jan 2023 19:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U02ef6yAy0koIdWRkkMPBlMYkDTBeGRAzbNB5vzZmkI=;
        b=NTV0eeDnv0PZXQX5LWGhgof88h5iO7BIfZGaHj1kaQ1u+kHu20uFFLE3RZtzZTedf/
         xjRG1cWmFqt8Hq88EXS+bf/e/oL8G2zM8t120uwsCP16hVxdTaOHq8BtDoKU5vkBKxI8
         z60/3P6wObpDIQYDVOPzBM7K24nDuMRJwI8sUA91NQ5JrK5zOeQJ1WUv8eblapKhoGoD
         qW/a6FBpNY9HzR/LVMubrJ7oF3QzQQ8I4QSpX4dkJgQlVEqtF84SGwFnuElWDuon58xk
         rkoJzC2F+x50bx4qlxysCHm8HdpFkKKqDt1/Rp+84l0jQog4f0G66I60rGSyRHJPM+Hq
         iqFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U02ef6yAy0koIdWRkkMPBlMYkDTBeGRAzbNB5vzZmkI=;
        b=jIvGK5yCMToW0XSPdkvMLh/1Wmsd6eXQlkpeYpaZ0DkP9xF3oqjMiU3c/HfGPtoPdO
         KbwB6Krl5POFda3xUU7D+MhytY0TwSQZH4b/xFzrfyzNciayYP79B84yTZPK1P/kSxU2
         /Yninap0aERvIaN4akmsxy+sNlCEep8sRekQmdXVEJyfDoXtUzER5WMhY7c/buNbdJzU
         ClpTBOWcYzcwvFA72Au3NLP4jH8yixDykU7BSqZC+U21EHF85IK5wY3VjVmD72JntKOk
         IMwsEz7g7fCRHHiRa3C6aznAj8fiJ5Bvx7vs5c7bHiAdjMH1vtk5QQMkYDlN6lWoBM40
         d+iA==
X-Gm-Message-State: AFqh2krYwlg0IFcIfQZSCF/EhhPB2270kAsaqOnUC0dB2Q4/0sPo5QYu
        yWOgYFP5Nz10qdxyIro1FvM=
X-Google-Smtp-Source: AMrXdXvdtqegGTzk4HPS1O4sgFeq/YYLAH27zJ1JCO+0+pQ0e4dSo1NxidqSFnY8Yj4U0oCFrRSeKw==
X-Received: by 2002:a05:6a00:2a9:b0:588:89bc:7f75 with SMTP id q9-20020a056a0002a900b0058889bc7f75mr12784790pfs.1.1673492937556;
        Wed, 11 Jan 2023 19:08:57 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id 194-20020a6214cb000000b005809d382016sm10691600pfu.74.2023.01.11.19.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 19:08:57 -0800 (PST)
Date:   Wed, 11 Jan 2023 19:08:55 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Erdem Aktas <erdemaktas@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v10 005/108] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <20230112030855.GA2034518@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <99e5fcf2a7127347816982355fd4141ee1038a54.1667110240.git.isaku.yamahata@intel.com>
 <CAAYXXYwQ_qBbug85QgMMN376FSZqoZypbTm9Gzc9wgY88AxX+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAYXXYwQ_qBbug85QgMMN376FSZqoZypbTm9Gzc9wgY88AxX+w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 11, 2023 at 02:02:58PM -0800,
Erdem Aktas <erdemaktas@google.com> wrote:

> On Sat, Oct 29, 2022 at 11:24 PM <isaku.yamahata@intel.com> wrote:
> >
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> > +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> > +{
> > +       int r;
> > +
> > +       if (!enable_ept) {
> > +               pr_warn("Cannot enable TDX with EPT disabled\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       /* MOVDIR64B instruction is needed. */
> > +       if (!static_cpu_has(X86_FEATURE_MOVDIR64B)) {
> > +               pr_warn("Cannot enable TDX with MOVDIR64B supported ");
> > +               return -ENODEV;
> > +       }
> > +
> > +       /* TDX requires VMX. */
> > +       r = vmxon_all();
> > +       if (!r)
> > +               r = tdx_module_setup();
> > +       vmxoff_all();
> 
> if few CPUs have VMX enabled, this will disable VMX in all of them.
> Depending on what enabled VMX on those CPUs, would this not cause
> kernel crashes/problems?

Are you seeing any issues? or is this a question in theory?

In theory, you're right.  In practice, unless we have other kernel components
that uses VMX, we don't have to worry.  In fact, only KVM in the kernel tree
uses VMX.

The flow is as follows,
- VMX is off on all CPUs on start up.
  NOTE: VMX is disabled on kexec or reboot.
- On loading kvm_intel.ko (or kernel boot if builtin), this function is called.
  vmxon/off_all()
- VMX is enabled on all online CPUs when creating the first guest.
- VMX is disabled on all online CPUs when destroying the last guest.
- VMX is disabled on offlining CPU

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

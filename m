Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9879F76B04A
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 12:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjHAKFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 06:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjHAKFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 06:05:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39AB01B6
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 03:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690884256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vaJhNgT5dHi6t1An3LbLPUe2A1bthkbgPOCCUSxNbas=;
        b=dUDxarKc062Pq+c9YpwuF4QxYd35MVHFwO0c6157RXGufGWjsOQjArf8bCKm0OAz7a/+0m
        InIGdzukKj+r1A2CPygbm9T0fYu+caowse+uuby9duRz8APD7oyI62ETpTEY2w78e03pGw
        M42coEnK4/evZi8mpX0MsCt2+Mm3RJA=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-Zvn2MJuzPaGeJu07OU5rSw-1; Tue, 01 Aug 2023 06:04:15 -0400
X-MC-Unique: Zvn2MJuzPaGeJu07OU5rSw-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4fe369ab20fso1887931e87.2
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 03:04:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690884253; x=1691489053;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vaJhNgT5dHi6t1An3LbLPUe2A1bthkbgPOCCUSxNbas=;
        b=U1NnE8xOBUx64djXnYPnpz47EagQZA/lcHwSNht45bZhdHX5MuE0Cy0toP1dz/Ah0z
         LIzxLhlTOJiJw3yH8H3+rv7Ae62hfPCaPsS4oxeMlsf8jgxWxjPNZ+xiQs5Bjyjjpxfw
         TEK6aT5wjEszgalj/ANfxyJqIghOwX7V1Ls/SbjxiQzyA35FJJRDgnrMQLJB3oJ0ac3v
         48fVmfqMY6J4zzMVGrDu2gl8M1U18z7FrfmQb/m88aShaTwIpJf8HmsrhF9MWqToxZMu
         q6m1aPIhSa24UXIf1Luo0tlok2OAcvnzKjkfwssE+Ncmgnn1f74YtP81LHJJ0VAkRdvX
         qrwQ==
X-Gm-Message-State: ABy/qLa+SfQpi0xaMDAFz9m0W5DkXO0+pTL00+T50mD36/z+B21+N0bb
        8PhjWW4ZA3iCfIhHjOUQgeYXMpoOg98tsGm8czM49aXCmXJmF1siRVxvSjl8c8Fd0FZOHC9Wjv0
        bBfyhLS+7yBqxMIe0mCIo
X-Received: by 2002:a19:384d:0:b0:4fb:97e8:bc1c with SMTP id d13-20020a19384d000000b004fb97e8bc1cmr1492004lfj.54.1690884253248;
        Tue, 01 Aug 2023 03:04:13 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHIMBqHeRkBCm6nslrtM9AMG9RrucErnURFZ2c6xFE6xjh94OXTXJ09I/LZG5OemVMUT9K0YQ==
X-Received: by 2002:a19:384d:0:b0:4fb:97e8:bc1c with SMTP id d13-20020a19384d000000b004fb97e8bc1cmr1491993lfj.54.1690884252900;
        Tue, 01 Aug 2023 03:04:12 -0700 (PDT)
Received: from starship ([77.137.131.138])
        by smtp.gmail.com with ESMTPSA id se9-20020a170906ce4900b0099364d9f0e6sm7425255ejb.117.2023.08.01.03.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 03:04:12 -0700 (PDT)
Message-ID: <8c7dfba9353a0dc1f2d68dd7db92ab9c5faedc29.camel@redhat.com>
Subject: Re: [Bug] AMD nested: commit broke VMware
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     jwarren@tutanota.com, Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, Kvm <kvm@vger.kernel.org>
Date:   Tue, 01 Aug 2023 13:04:10 +0300
In-Reply-To: <NakHQwK--3-9@tutanota.com>
References: <NWb_YOE--3-9@tutanota.com>
         <357d135f9ed65f4e2970c82ae4e855547db70ad1.camel@redhat.com>
         <CALMp9eTyx1Y0yc7G0c0BsAig=Amv4DYtcNnWPmD-9JHP=ChZiw@mail.gmail.com>
         <CALMp9eSq1r87=jGWc1z85L-QGCTF-jpWgHEQxJ4sVCqCU_0KQQ@mail.gmail.com>
         <5e18e1424868eec10f6dc396b88b65283b57278a.camel@redhat.com>
         <ZHdcjFPJJwl9RoxF@google.com>
         <CALMp9eTti7gSNKgR=h__SsoKynaR1tR2nHhuk_6tse-3FHJ7mw@mail.gmail.com-NWmRa0I----9>
         <NakHQwK--3-9@tutanota.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У вт, 2023-08-01 у 10:49 +0200, jwarren@tutanota.com пише:
> Hi
> Are there any thoughts on this?
> 
> PS As I see it, that commit didn't fix any real problem (up to 5.15 nothing was broken that required it), but did break nested VMWare Workstation/ESXi for people that use it (yes, it's vmware's code bug, but doubt they will fix it).
> 
> 
> May 31, 2023, 15:34 by jmattson@google.com:
> 
> > On Wed, May 31, 2023 at 7:41 AM Sean Christopherson <seanjc@google.com> wrote:
> > 
> > > On Wed, May 31, 2023, Maxim Levitsky wrote:
> > > > У вт, 2023-05-30 у 13:34 -0700, Jim Mattson пише:
> > > > > On Tue, May 30, 2023 at 1:10 PM Jim Mattson <jmattson@google.com> wrote:
> > > > > > On Mon, May 29, 2023 at 6:44 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > > > > > У пн, 2023-05-29 у 14:58 +0200, jwarren@tutanota.com пише:
> > > > > > > > I don't know what would be the best case here, maybe put a quirk
> > > > > > > > there, so it doesn't break "userspace".  Committer's email is dead,
> > > > > > > > so I'm writing here.
> > > > > > > > 
> > > > > > > 
> > > > > > > I have to say that I know about this for long time, because some time
> > > > > > > ago I used  to play with VMware player in a VM on AMD on my spare time,
> > > > > > > on weekends (just doing various crazy things with double nesting,
> > > > > > > running win98 nested, vfio stuff, etc, etc).
> > > > > > > 
> > > > > > > I didn't report it because its a bug in VMWARE - they set a bit in the
> > > > > > > tlb_control without checking CPUID's FLUSHBYASID which states that KVM
> > > > > > > doesn't support setting this bit.
> > > > > > 
> > > > > > I am pretty sure that bit 1 is supposed to be ignored on hardware
> > > > > > without FlushByASID, but I'll have to see if I can dig up an old APM
> > > > > > to verify that.
> > > > > 
> > > > > I couldn't find an APM that old, but even today's APM does not specify
> > > > > that any checks are performed on the TLB_CONTROL field by VMRUN.
> > > > > 
> > > > > While Intel likes to fail VM-entry for illegal VMCS state, AMD prefers
> > > > > to massage the VMCB to render any illegal VMCB state legal. For
> > > > > example, rather than fail VM-entry for a non-canonical address, AMD is
> > > > > inclined to drop the high bits and sign-extend the low bits, so that
> > > > > the address is canonical.
> > > > > 
> > > > > I'm willing to bet that modern CPUs continue to ignore the TLB_CONTROL
> > > > > bits that were noted "reserved" in version 3.22 of the manual, and
> > > > > that Krish simply manufactured the checks in commit 174a921b6975
> > > > > ("nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB"),
> > > > > without cause.
> > > 
> > > Ya.  The APM even provides a definition of "reserved" that explicitly calls out
> > > the different reserved qualifiers.  The only fields/values that KVM can actively
> > > enforce are things tagged MBZ.
> > > 
> > >  reserved
> > >  Fields marked as reserved may be used at some future time.
> > >  To preserve compatibility with future processors, reserved fields require special handling when
> > >  read or written by software. Software must not depend on the state of a reserved field (unless
> > >  qualified as RAZ), nor upon the ability of such fields to return a previously written state.
> > >  If a field is marked reserved without qualification, software must not change the state of that field;
> > >  it must reload that field with the same value returned from a prior read.
> > >  Reserved fields may be qualified as IGN, MBZ, RAZ, or SBZ (see definitions).
> > > 
> > > > > > > Supporting FLUSHBYASID would fix this, and make nesting faster too,
> > > > > > > but it is far from a trivial job.
> > > > > > > 
> > > > > > > I hope that I will find time to do this soon.
> > > 
> > > ...
> > > 
> > > > Shall we revert the offending patch then?
> > > 
> > > Yes please.
> > > 
> > 
> > It's not quite that simple.
> > 
> > The vmcb12 TLB_CONTROL field needs to be sanitized on its way into the
> > vmcb02 (perhaps in nested_copy_vmcb_control_to_cache()?). Bits 63:2
> > should be cleared. Also, if the guest CPUID does not advertise support
> > for FlushByASID, then bit 1 should be cleared. Note that the vmcb12
> > TLB_CONTROL field itself must not be modified, since the APM
> > specifically states, "The VMRUN instruction reads, but does not
> > change, the value of the TLB_CONTROL field."
> > 

I will prepare a patch for this hopefully this week. 
Jim mentioned that a revert is not full solution for this.

Best regards,
	Maxim Levitsky


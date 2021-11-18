Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8379B455219
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 02:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242193AbhKRBWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 20:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242174AbhKRBWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 20:22:39 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44961C061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 17:19:40 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id h24so3791365pjq.2
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 17:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R0Zw8wcDSXsa3WAhRYHWSbV2JP7EN2Oe5l2I61VKZ7U=;
        b=CqO6PRm2DcZD7l7dscUM0meQfr+JgCmJ86nKpR3BNFAes2VmAUv+iho3ZOHMz7lUUV
         AaFEIJrSlT8KpGBcFal0F71x78CwkinpkQyQqWBft82fgdxWv+KwVVFeY51OlRimNo5Z
         AkrK94lXOS2Dw7cuKFwt6LcuYorqGyfTdoh0JvgiTRCZ8yGJf3kwM+HQnej5qDcbICyi
         p9nBwv6Iwf1TTxLxgGniyOMEMHeANTqLb0LH0ZNf4ruBNJoCFLJEw7xxdyHvBX+XYoXe
         cU9v98e2xYD/Fl3KR+W1fUk8oJy4D0+YZKjPaq2AcvqXN2WSva0qe+OZMTO+GKWR5lGQ
         JZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R0Zw8wcDSXsa3WAhRYHWSbV2JP7EN2Oe5l2I61VKZ7U=;
        b=53bvfmftGYe0xFkCiKV7lNGtxRUraxlPOJLAgvSuDAKoy6snmlzl1svPtFkwHCLU/s
         G2WBsv24NzwVe/jpL/U6u9TgPp0p2ZSma/gYsBe8/z6YI53c63kNOFs3pTeRnkMr/QOR
         Nh61wyOGre9rOriPrD6ChqDFgg3rRXIsqCKMbtw0Rq2I38pI5LNT4peIQoozNTEdr2ll
         AvtKBeTlLTEAkZvElTH1CqK3Cc6vruSHP056D8wbbMSjbkhrN9EdLevMLyajgDgCRWZF
         ywgpb8yG7907ZwGa233aOyQksclMxyjtZHHt19MSU/DC4lfP3lMdiNNZ4SN6rYESegg6
         hx7Q==
X-Gm-Message-State: AOAM532MetBYAFCj7GZH1+lOxbj2PeANax9sz0lskqUiS5pAjvN438X/
        I5jdIG0vwRPfH5v52409iLxonQ==
X-Google-Smtp-Source: ABdhPJzDSpDBUFH7PHioMGoNxz1NE2+zU4tyS8GjtYSaeWxuz75EqMOymOPiNhoiby6UmXj9vYk6lQ==
X-Received: by 2002:a17:90b:4b89:: with SMTP id lr9mr5361350pjb.49.1637198379709;
        Wed, 17 Nov 2021 17:19:39 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ng9sm7407071pjb.4.2021.11.17.17.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 17:19:39 -0800 (PST)
Date:   Thu, 18 Nov 2021 01:19:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>,
        Jim Mattson <jmattson@google.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
Message-ID: <YZWqJwUrF2Id9hM2@google.com>
References: <CALMp9eT+uAvPv7LhJKrJGDN31-aVy6DYBrP+PUDiTk0zWuCX4g@mail.gmail.com>
 <YVzeJ59/yCpqgTX2@google.com>
 <20211008082302.txckaasmsystigeu@linux.intel.com>
 <85da4484902e5a4b1be645669c95dba7934d98b5.camel@linux.intel.com>
 <CALMp9eTSkK2+-W8AVRdYv3MEsMKj-Xc2-v7DsavJRh5FLsVuCQ@mail.gmail.com>
 <3360abf3841a5d3234ac5983dd2df62b24e5fc47.camel@linux.intel.com>
 <CALMp9eQruRB3WEuwe2PEyEmbYUcJC_vR86Dd_wPTuqjb212h+w@mail.gmail.com>
 <32f506647ff99f58441ed1281c1db84599d48c8c.camel@linux.intel.com>
 <YYr3R8ehb/1tsCDj@google.com>
 <20211110053548.tewdtkebhl77dmye@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110053548.tewdtkebhl77dmye@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 10, 2021, Yu Zhang wrote:
> On Tue, Nov 09, 2021 at 10:33:43PM +0000, Sean Christopherson wrote:
> > On Wed, Nov 03, 2021, Robert Hoo wrote:
> > > On Fri, 2021-10-29 at 12:53 -0700, Jim Mattson wrote:
> > > > On Fri, Oct 8, 2021 at 5:05 PM Robert Hoo <robert.hu@linux.intel.com>
> > > > wrote:
> > > > > 
> > > > > On Fri, 2021-10-08 at 16:49 -0700, Jim Mattson wrote:
> > > > > > We have some internal patches for virtualizing VMCS shadowing
> > > > > > which
> > > > > > may break if there is a guest VMCS field with index greater than
> > > > > > VMX_VMCS_ENUM.MAX_INDEX. I plan to upstream them soon.
> > > > > 
> > > > > OK, thanks for letting us know.:-)
> > > > 
> > > > After careful consideration, we're actually going to drop these
> > > > patches rather than sending them upstream.
> > > 
> > > OK.
> > > 
> > > Hi, Paolo, Sean and Jim,
> > > 
> > > Do you think our this series patch are still needed or can be dropped
> > > as well?
> > 
> > IMO we should drop this series and take our own erratum.
> > 
> 
> Thanks, Sean.
> 
> Do we need a patch in kvm-unit-test to depricate the check against
> the max index from MSR_IA32_VMX_VMCS_ENUM?

Hmm, yes, unless there's an easy way to tell QEMU to not override the VMX MSRs.
I don't see any point in fighting too hard with QEMU.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2D2392D1D
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 13:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbhE0LxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 07:53:05 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:15063 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbhE0LxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 07:53:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1622116292; x=1653652292;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=/b+CzBHyllLAb9T0raLjpOuY5FSoP8nR4EMXd2L8x8o=;
  b=PNFnuD9pv7o7EHR3XiUAeNpxbs00QPdA1c/dFXNZVwc8VeWF3GWCHMMQ
   3EuQeZrmHACdvhfSusfe0/VHX8EBbRbV0dNNIY4ClUPDL03UJAqXSnyDA
   yC2i+gNkMA955mi/dv0cmi09aYz9DKAa75ZfHlj5l3VRTbg5BegGgM7kt
   I=;
X-IronPort-AV: E=Sophos;i="5.82,334,1613433600"; 
   d="scan'208";a="3610143"
Subject: Re: Windows fails to boot after rebase to QEMU master
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 27 May 2021 11:51:26 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id E3D04A2133;
        Thu, 27 May 2021 11:51:23 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.97) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 27 May 2021 11:51:18 +0000
Date:   Thu, 27 May 2021 13:51:14 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Claudio Fontana <cfontana@suse.de>
CC:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        <qemu-devel@nongnu.org>, Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20210527115113.GA4143@uc8bbc9586ea454.ant.amazon.com>
References: <20210521091451.GA6016@u366d62d47e3651.ant.amazon.com>
 <20210524055322-mutt-send-email-mst@kernel.org>
 <YK6hunkEnft6VJHz@work-vm>
 <d71fee00-0c21-c5e8-dbc6-00b7ace11c5a@suse.de>
 <YK9Y64U0wjU5K753@work-vm>
 <16a5085f-868b-7e1a-f6de-1dab16103a66@redhat.com>
 <YK9jOdCPUGQF4t0D@work-vm>
 <855c9f5c-a8e8-82b4-d71e-db9c966ddcc3@suse.de>
 <3b8f2f3b-0254-22c1-6391-44569c8ff821@suse.de>
 <d43ca6d9-d00c-6c2e-6838-36554de3fba5@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d43ca6d9-d00c-6c2e-6838-36554de3fba5@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.161.97]
X-ClientProxiedBy: EX13D37UWC003.ant.amazon.com (10.43.162.183) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 27, 2021 at 01:36:37PM +0200, Claudio Fontana wrote:
> Just to check whether this is actually the issue we are talking about,
> Sid et al, could you try this?
> 
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index c496bfa1c2..810c46281b 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -4252,6 +4252,7 @@ static void max_x86_cpu_initfn(Object *obj)
>      object_property_set_str(OBJECT(cpu), "model-id",
>                              "QEMU TCG CPU version " QEMU_HW_VERSION,
>                              &error_abort);
> +    accel_cpu_instance_init(CPU(cpu));
>  }
> 
>  static const TypeInfo max_x86_cpu_type_info = {
> ------------------------------------------------------------------------------------------
> 
> Does this band-aid happen to cover-up the issue?

Yes it does fix the issue for me. Thanks.

~ Sid.

> I need to think about the proper fix though, any suggestions Paolo,
> Eduardo?
> 
> The pickle here is that we'd need to call the accelerator specific
> initialization of the x86 accel-cpu only after the x86 cpu subclass
> initfn, otherwise the accel-specific cpu initialization code has no
> chance to see the subclass (max) trying to set ->max_features.
> 
> C.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879




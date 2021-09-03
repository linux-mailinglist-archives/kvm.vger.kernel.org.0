Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3711B40024B
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 17:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349669AbhICP3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 11:29:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48865 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349745AbhICP3G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 11:29:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630682885;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=3LR7REeezVsIp3SNM2nZhl+ZtoLMOZo4uM0Zo8Y4Lwo=;
        b=EwvGx8ViMRezWnX2ce0l2vAZeblkoRnZuXM3Oy6yiEpWggVOPWKie3v4y8OU62hR3g3weM
        9p9hDHG6E7f5fgdK0XJQAO/tNz0tbSmXS9Dgf/6z/Q58IjwbAq2cFMunRHDjVjhBmkZPvf
        skVun5TqpshADmRNc0jmqo3oiQX02GM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-lwRSrDa-PteO7D9H_m_qzw-1; Fri, 03 Sep 2021 11:28:04 -0400
X-MC-Unique: lwRSrDa-PteO7D9H_m_qzw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1015784A5E1;
        Fri,  3 Sep 2021 15:28:03 +0000 (UTC)
Received: from redhat.com (unknown [10.39.193.241])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BAD65D9D3;
        Fri,  3 Sep 2021 15:27:59 +0000 (UTC)
Date:   Fri, 3 Sep 2021 16:27:56 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     qemu-devel@nongnu.org, Connor Kuehl <ckuehl@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: Re: [RFC PATCH v2 12/12] i386/sev: update query-sev QAPI format to
 handle SEV-SNP
Message-ID: <YTI+/A/ejS/tlYMf@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-13-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210826222627.3556-13-michael.roth@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021 at 05:26:27PM -0500, Michael Roth wrote:
> Most of the current 'query-sev' command is relevant to both legacy
> SEV/SEV-ES guests and SEV-SNP guests, with 2 exceptions:
> 
>   - 'policy' is a 64-bit field for SEV-SNP, not 32-bit, and
>     the meaning of the bit positions has changed
>   - 'handle' is not relevant to SEV-SNP

If the host supports SEV-SNP guests, is it still possible for mgmt
app to create guests using the  "legacy" SEV/SEV-ES approach ? ie
is the hardware backwards compatible, or is it strictly required
to always create SEV-SNP guests when the hardware is capable ?

The code here seems to imply a non-backwards compatible approach,
mandating use of SEV-SNP guests on such capable kernel/hardware.

> To address this, this patch adds a new 'sev-type' field that can be
> used as a discriminator to select between SEV and SEV-SNP-specific
> fields/formats without breaking compatibility for existing management
> tools (so long as management tools that add support for launching
> SEV-SNP guest update their handling of query-sev appropriately).
> 
> The corresponding HMP command has also been fixed up similarly.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  qapi/misc-target.json  | 71 +++++++++++++++++++++++++++++++++---------
>  target/i386/monitor.c  | 29 +++++++++++++----
>  target/i386/sev.c      | 22 +++++++------
>  target/i386/sev_i386.h |  3 ++
>  4 files changed, 95 insertions(+), 30 deletions(-)
> 
> diff --git a/qapi/misc-target.json b/qapi/misc-target.json
> index 3b05ad3dbf..80f994ff9b 100644
> --- a/qapi/misc-target.json
> +++ b/qapi/misc-target.json
> @@ -81,6 +81,49 @@
>             'send-update', 'receive-update' ],
>    'if': 'TARGET_I386' }
>  
> +##
> +# @SevGuestType:
> +#
> +# An enumeration indicating the type of SEV guest being run.
> +#
> +# @sev:     The guest is a legacy SEV or SEV-ES guest.
> +# @sev-snp: The guest is an SEV-SNP guest.
> +#
> +# Since: 6.2
> +##
> +{ 'enum': 'SevGuestType',
> +  'data': [ 'sev', 'sev-snp' ],
> +  'if': 'TARGET_I386' }
> +
> +##
> +# @SevGuestInfo:
> +#
> +# Information specific to legacy SEV/SEV-ES guests.
> +#
> +# @policy: SEV policy value
> +#
> +# @handle: SEV firmware handle
> +#
> +# Since: 2.12
> +##
> +{ 'struct': 'SevGuestInfo',
> +  'data': { 'policy': 'uint32',
> +            'handle': 'uint32' },
> +  'if': 'TARGET_I386' }
> +
> +##
> +# @SevSnpGuestInfo:
> +#
> +# Information specific to SEV-SNP guests.
> +#
> +# @policy: SEV-SNP policy value
> +#
> +# Since: 6.2
> +##
> +{ 'struct': 'SevSnpGuestInfo',
> +  'data': { 'policy': 'uint64' },
> +  'if': 'TARGET_I386' }
> +
>  ##
>  # @SevInfo:
>  #
> @@ -94,25 +137,25 @@
>  #
>  # @build-id: SEV FW build id
>  #
> -# @policy: SEV policy value
> -#
>  # @state: SEV guest state
>  #
> -# @handle: SEV firmware handle
> +# @sev-type: Type of SEV guest being run
>  #
>  # Since: 2.12
>  ##
> -{ 'struct': 'SevInfo',
> -    'data': { 'enabled': 'bool',
> -              'api-major': 'uint8',
> -              'api-minor' : 'uint8',
> -              'build-id' : 'uint8',
> -              'policy' : 'uint32',
> -              'state' : 'SevState',
> -              'handle' : 'uint32'
> -            },
> -  'if': 'TARGET_I386'
> -}
> +{ 'union': 'SevInfo',
> +  'base': { 'enabled': 'bool',
> +            'api-major': 'uint8',
> +            'api-minor' : 'uint8',
> +            'build-id' : 'uint8',
> +            'state' : 'SevState',
> +            'sev-type' : 'SevGuestType' },
> +  'discriminator': 'sev-type',
> +  'data': {
> +      'sev': 'SevGuestInfo',
> +      'sev-snp': 'SevSnpGuestInfo' },
> +  'if': 'TARGET_I386' }
> +
>  
>  ##
>  # @query-sev:
> diff --git a/target/i386/monitor.c b/target/i386/monitor.c
> index 119211f0b0..85a8bc2bef 100644
> --- a/target/i386/monitor.c
> +++ b/target/i386/monitor.c
> @@ -692,20 +692,37 @@ void hmp_info_sev(Monitor *mon, const QDict *qdict)
>  {
>      SevInfo *info = sev_get_info();
>  
> -    if (info && info->enabled) {
> -        monitor_printf(mon, "handle: %d\n", info->handle);
> +    if (!info || !info->enabled) {
> +        monitor_printf(mon, "SEV is not enabled\n");
> +        goto out;
> +    }
> +
> +    if (sev_snp_enabled()) {
>          monitor_printf(mon, "state: %s\n", SevState_str(info->state));
>          monitor_printf(mon, "build: %d\n", info->build_id);
>          monitor_printf(mon, "api version: %d.%d\n",
>                         info->api_major, info->api_minor);
>          monitor_printf(mon, "debug: %s\n",
> -                       info->policy & SEV_POLICY_NODBG ? "off" : "on");
> -        monitor_printf(mon, "key-sharing: %s\n",
> -                       info->policy & SEV_POLICY_NOKS ? "off" : "on");
> +                       info->u.sev_snp.policy & SEV_SNP_POLICY_DBG ? "on"
> +                                                                   : "off");
> +        monitor_printf(mon, "SMT allowed: %s\n",
> +                       info->u.sev_snp.policy & SEV_SNP_POLICY_SMT ? "on"
> +                                                                   : "off");
> +        monitor_printf(mon, "SEV type: %s\n", SevGuestType_str(info->sev_type));
>      } else {
> -        monitor_printf(mon, "SEV is not enabled\n");
> +        monitor_printf(mon, "handle: %d\n", info->u.sev.handle);
> +        monitor_printf(mon, "state: %s\n", SevState_str(info->state));
> +        monitor_printf(mon, "build: %d\n", info->build_id);
> +        monitor_printf(mon, "api version: %d.%d\n",
> +                       info->api_major, info->api_minor);
> +        monitor_printf(mon, "debug: %s\n",
> +                       info->u.sev.policy & SEV_POLICY_NODBG ? "off" : "on");
> +        monitor_printf(mon, "key-sharing: %s\n",
> +                       info->u.sev.policy & SEV_POLICY_NOKS ? "off" : "on");
> +        monitor_printf(mon, "SEV type: %s\n", SevGuestType_str(info->sev_type));
>      }
>  
> +out:
>      qapi_free_SevInfo(info);
>  }
>  
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 72a6146295..fac2755e68 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -704,25 +704,27 @@ sev_get_info(void)
>  {
>      SevInfo *info;
>      SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
> -    SevGuestState *sev_guest =
> -        (SevGuestState *)object_dynamic_cast(OBJECT(sev_common),
> -                                             TYPE_SEV_GUEST);
>  
>      info = g_new0(SevInfo, 1);
>      info->enabled = sev_enabled();
>  
>      if (info->enabled) {
> -        if (sev_guest) {
> -            info->handle = sev_guest->handle;
> -        }
>          info->api_major = sev_common->api_major;
>          info->api_minor = sev_common->api_minor;
>          info->build_id = sev_common->build_id;
>          info->state = sev_common->state;
> -        /* we only report the lower 32-bits of policy for SNP, ok for now... */
> -        info->policy =
> -            (uint32_t)object_property_get_uint(OBJECT(sev_common),
> -                                               "policy", NULL);
> +
> +        if (sev_snp_enabled()) {
> +            info->sev_type = SEV_GUEST_TYPE_SEV_SNP;
> +            info->u.sev_snp.policy =
> +                object_property_get_uint(OBJECT(sev_common), "policy", NULL);
> +        } else {
> +            info->sev_type = SEV_GUEST_TYPE_SEV;
> +            info->u.sev.handle = SEV_GUEST(sev_common)->handle;
> +            info->u.sev.policy =
> +                (uint32_t)object_property_get_uint(OBJECT(sev_common),
> +                                                   "policy", NULL);
> +        }
>      }
>  
>      return info;
> diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
> index e0e1a599be..948d8f1079 100644
> --- a/target/i386/sev_i386.h
> +++ b/target/i386/sev_i386.h
> @@ -28,6 +28,9 @@
>  #define SEV_POLICY_DOMAIN       0x10
>  #define SEV_POLICY_SEV          0x20
>  
> +#define SEV_SNP_POLICY_SMT      0x10000
> +#define SEV_SNP_POLICY_DBG      0x80000
> +
>  extern bool sev_es_enabled(void);
>  extern bool sev_snp_enabled(void);
>  extern uint64_t sev_get_me_mask(void);
> -- 
> 2.25.1
> 

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


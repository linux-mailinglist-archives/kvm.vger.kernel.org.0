Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B423135D34
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732649AbgAIPwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 10:52:54 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57880 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732608AbgAIPwx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 10:52:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578585172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zdpsRvVV+rWRsUq3Er8dozQIkuoysYx4uKpmTNPoOUA=;
        b=Kcd3vzhBO+N7P12vlfs1mdyIxBhxFV20Mt/k3Rf+hnUETC6gxrpqrNkC0EZGV51o+yOQSt
        YVW4VO82pOHw97uDcbRJAgqwEtJb3YOApcq91AxgfhcrobJIzyfMGwf2vbLAhRcAOha5y6
        dtJXh2Gmq3WXpcjQC9MnkLPZSKB+f58=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-FRT1QSlLOnmD2luXA1AkkA-1; Thu, 09 Jan 2020 10:52:48 -0500
X-MC-Unique: FRT1QSlLOnmD2luXA1AkkA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBF6E802C96;
        Thu,  9 Jan 2020 15:52:46 +0000 (UTC)
Received: from work-vm (unknown [10.36.118.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF1565F700;
        Thu,  9 Jan 2020 15:52:40 +0000 (UTC)
Date:   Thu, 9 Jan 2020 15:52:38 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>,
        Juan Quintela <quintela@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        qemu-ppc@nongnu.org, Richard Henderson <rth@twiddle.net>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 06/15] migration/savevm: Replace current_machine by
 qdev_get_machine()
Message-ID: <20200109155238.GK6795@work-vm>
References: <20200109152133.23649-1-philmd@redhat.com>
 <20200109152133.23649-7-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20200109152133.23649-7-philmd@redhat.com>
User-Agent: Mutt/1.13.0 (2019-11-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Philippe Mathieu-Daud=E9 (philmd@redhat.com) wrote:
> As we want to remove the global current_machine,
> replace MACHINE_GET_CLASS(current_machine) by
> MACHINE_GET_CLASS(qdev_get_machine()).
>=20
> Signed-off-by: Philippe Mathieu-Daud=E9 <philmd@redhat.com>
> ---
>  migration/savevm.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/migration/savevm.c b/migration/savevm.c
> index 59efc1981d..0e8b6a4715 100644
> --- a/migration/savevm.c
> +++ b/migration/savevm.c
> @@ -292,7 +292,8 @@ static uint32_t get_validatable_capabilities_count(=
void)
>  static int configuration_pre_save(void *opaque)
>  {
>      SaveState *state =3D opaque;
> -    const char *current_name =3D MACHINE_GET_CLASS(current_machine)->n=
ame;
> +    MachineClass *mc =3D MACHINE_GET_CLASS(qdev_get_machine());
> +    const char *current_name =3D mc->name;

For migration:

Acked-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

(Personally I'd keep it on one line, but that's just taste)


>      MigrationState *s =3D migrate_get_current();
>      int i, j;
> =20
> @@ -362,7 +363,8 @@ static bool configuration_validate_capabilities(Sav=
eState *state)
>  static int configuration_post_load(void *opaque, int version_id)
>  {
>      SaveState *state =3D opaque;
> -    const char *current_name =3D MACHINE_GET_CLASS(current_machine)->n=
ame;
> +    MachineClass *mc =3D MACHINE_GET_CLASS(qdev_get_machine());
> +    const char *current_name =3D mc->name;
> =20
>      if (strncmp(state->name, current_name, state->len) !=3D 0) {
>          error_report("Machine type received is '%.*s' and local is '%s=
'",
> @@ -615,9 +617,7 @@ static void dump_vmstate_vmsd(FILE *out_file,
> =20
>  static void dump_machine_type(FILE *out_file)
>  {
> -    MachineClass *mc;
> -
> -    mc =3D MACHINE_GET_CLASS(current_machine);
> +    MachineClass *mc =3D MACHINE_GET_CLASS(qdev_get_machine());
> =20
>      fprintf(out_file, "  \"vmschkmachine\": {\n");
>      fprintf(out_file, "    \"Name\": \"%s\"\n", mc->name);
> --=20
> 2.21.1
>=20
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A7A3C5E69
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 16:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbhGLOhS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 10:37:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230297AbhGLOhR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Jul 2021 10:37:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626100468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T6eQq3XWcEoAW6uPl9N3Silx/ooSBWP8Ld9oFAwnjWA=;
        b=bn8jQfwueWdeZRryvIdJx9NpFklMG0drY/TXnsqcD7uurgiMJ66YLh9CslxmWV2vqFzaHg
        MCBAKsg9Kw4Ftydkq5mvgGV5eYn4/THTb8lNUiXhn3G7UyHscIC3WSIyiD+LOOFnK1SKBq
        vFEWwMr4N3RF2xojWI7Ygw2KAPz8lp0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-5Jsk7f1uPQq9k1PYgtrgjA-1; Mon, 12 Jul 2021 10:34:22 -0400
X-MC-Unique: 5Jsk7f1uPQq9k1PYgtrgjA-1
Received: by mail-wm1-f72.google.com with SMTP id 7-20020a05600c22c7b0290227b752f429so249519wmg.4
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 07:34:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=T6eQq3XWcEoAW6uPl9N3Silx/ooSBWP8Ld9oFAwnjWA=;
        b=AKTv6C8+IppH0BjLtD0IWu0SUYvVn587tqwM3ooWLROCnJ6yb60Mvx08FStIvhUhSM
         wfKLfK7cJN1d27TJWUGmm+8q7uFSG2bh7n44K/7r6OzW5u78d0cFh2RKXrJ9lQnzZGUy
         u8LGOvzw9dmGM8gBHaoul1RwX3MhJY8Jgx0I8VhBCQ1vur/W5FEGlkBpb3X2UbykCX0M
         wGLKKh5Sod162Nyo81osR6IlCDcvmAZ/isBvxTkKCIfdJlj1bgvjsXXv+D+xF0uJVoS6
         b/dxSMHJcnfdxLMnMB35YLtXkTxYzhzQ6HZwfX7nQ66JJNUY+2mn23vTolsBTaKZT/Gb
         K9Mg==
X-Gm-Message-State: AOAM531TzduF8lqyphLNyIjeSlopIKLVSQupH13SOb6gaPQ21vvQGNHL
        Julk/97D/JyQWrCrsauuWQD9KIGTCTC3nlVcQZrR8KsuONgqh/AoCOzTWycxuhD7KKyTIZuLEDW
        4mZBy5HTMBrYw
X-Received: by 2002:a5d:414b:: with SMTP id c11mr19766954wrq.162.1626100461100;
        Mon, 12 Jul 2021 07:34:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3AbPlZGuSMvud2+P7ovd6XxR/Y/u3CbTbRO4Z7z6YNiuWxyhGChxMemDJ4kVyTBYzmRYbKw==
X-Received: by 2002:a5d:414b:: with SMTP id c11mr19766920wrq.162.1626100460881;
        Mon, 12 Jul 2021 07:34:20 -0700 (PDT)
Received: from work-vm (cpc109021-salf6-2-0-cust453.10-2.cable.virginm.net. [82.29.237.198])
        by smtp.gmail.com with ESMTPSA id b187sm7832753wmd.40.2021.07.12.07.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 07:34:20 -0700 (PDT)
Date:   Mon, 12 Jul 2021 15:34:17 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Brijesh Singh <brijesh.singh@amd.com>, armbru@redhat.com
Cc:     qemu-devel@nongnu.org, Connor Kuehl <ckuehl@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 2/6] i386/sev: extend sev-guest property to include
 SEV-SNP
Message-ID: <YOxS6R5NADizMui2@work-vm>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-3-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709215550.32496-3-brijesh.singh@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

cc'ing in armbru, since he knows about our command line - have we got a
neater way of doing this, or something else that reads config file?
Could the existing -readconfig work?

Although this is a fairly large chunk of data, I don't think it's any
larger than our block device configs on a bad day.

Dave

* Brijesh Singh (brijesh.singh@amd.com) wrote:
> To launch the SEV-SNP guest, a user can specify up to 8 parameters.
> Passing all parameters through command line can be difficult. To simplify
> the launch parameter passing, introduce a .ini-like config file that can be
> used for passing the parameters to the launch flow.
> 
> The contents of the config file will look like this:
> 
> $ cat snp-launch.init
> 
> # SNP launch parameters
> [SEV-SNP]
> init_flags = 0
> policy = 0x1000
> id_block = "YWFhYWFhYWFhYWFhYWFhCg=="

Wouldn't the 'gosvw' and 'hostdata' also be in there?

Dave

> 
> Add 'snp' property that can be used to indicate that SEV guest launch
> should enable the SNP support.
> 
> SEV-SNP guest launch examples:
> 
> 1) launch without additional parameters
> 
>   $(QEMU_CLI) \
>     -object sev-guest,id=sev0,snp=on
> 
> 2) launch with optional parameters
>   $(QEMU_CLI) \
>     -object sev-guest,id=sev0,snp=on,launch-config=<file>
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  docs/amd-memory-encryption.txt |  81 +++++++++++-
>  qapi/qom.json                  |   6 +
>  target/i386/sev.c              | 227 +++++++++++++++++++++++++++++++++
>  3 files changed, 312 insertions(+), 2 deletions(-)
> 
> diff --git a/docs/amd-memory-encryption.txt b/docs/amd-memory-encryption.txt
> index ffca382b5f..322bf38f68 100644
> --- a/docs/amd-memory-encryption.txt
> +++ b/docs/amd-memory-encryption.txt
> @@ -22,8 +22,8 @@ support for notifying a guest's operating system when certain types of VMEXITs
>  are about to occur. This allows the guest to selectively share information with
>  the hypervisor to satisfy the requested function.
>  
> -Launching
> ----------
> +Launching (SEV and SEV-ES)
> +--------------------------
>  Boot images (such as bios) must be encrypted before a guest can be booted. The
>  MEMORY_ENCRYPT_OP ioctl provides commands to encrypt the images: LAUNCH_START,
>  LAUNCH_UPDATE_DATA, LAUNCH_MEASURE and LAUNCH_FINISH. These four commands
> @@ -113,6 +113,83 @@ a SEV-ES guest:
>   - Requires in-kernel irqchip - the burden is placed on the hypervisor to
>     manage booting APs.
>  
> +Launching (SEV-SNP)
> +-------------------
> +Boot images (such as bios) must be encrypted before a guest can be booted. The
> +MEMORY_ENCRYPT_OP ioctl provides commands to encrypt the images:
> +KVM_SNP_INIT, SNP_LAUNCH_START, SNP_LAUNCH_UPDATE, and SNP_LAUNCH_FINISH. These
> +four commands together generate a fresh memory encryption key for the VM,
> +encrypt the boot images for a successful launch.
> +
> +KVM_SNP_INIT is called first to initialize the SEV-SNP firmware and SNP
> +features in the KVM. The feature flags value can be provided through the
> +launch-config file.
> +
> ++------------+-------+----------+---------------------------------+
> +| key        | type  | default  | meaning                         |
> ++------------+-------+----------+---------------------------------+
> +| init_flags | hex   | 0        | SNP feature flags               |
> ++-----------------------------------------------------------------+
> +
> +Note: currently the init_flags must be zero.
> +
> +SNP_LAUNCH_START is called first to create a cryptographic launch context
> +within the firmware. To create this context, guest owner must provide a guest
> +policy and other parameters as described in the SEV-SNP firmware
> +specification. The launch parameters should be specified in the launch-config
> +ini file and should be treated as a binary blob and must be passed as-is to
> +the SEV-SNP firmware.
> +
> +The SNP_LAUNCH_START uses the following parameters from the launch-config
> +file. See the SEV-SNP specification for more details.
> +
> ++--------+-------+----------+----------------------------------------------+
> +| key    | type  | default  | meaning                                      |
> ++--------+-------+----------+----------------------------------------------+
> +| policy | hex   | 0x30000  | a 64-bit guest policy                        |
> +| imi_en | bool  | 0        | 1 when IMI is enabled                        |
> +| ma_end | bool  | 0        | 1 when migration agent is used               |
> +| gosvw  | string| 0        | 16-byte base64 encoded string for the guest  |
> +|        |       |          | OS visible workaround.                       |
> ++--------+-------+----------+----------------------------------------------+
> +
> +SNP_LAUNCH_UPDATE encrypts the memory region using the cryptographic context
> +created via the SNP_LAUNCH_START command. If required, this command can be called
> +multiple times to encrypt different memory regions. The command also calculates
> +the measurement of the memory contents as it encrypts.
> +
> +SNP_LAUNCH_FINISH finalizes the guest launch flow. Optionally, while finalizing
> +the launch the firmware can perform checks on the launch digest computing
> +through the SNP_LAUNCH_UPDATE. To perform the check the user must supply
> +the id block, authentication blob and host data that should be included in the
> +attestation report. See the SEV-SNP spec for further details.
> +
> +The SNP_LAUNCH_FINISH uses the following parameters from the launch-config file.
> +
> ++------------+-------+----------+----------------------------------------------+
> +| key        | type  | default  | meaning                                      |
> ++------------+-------+----------+----------------------------------------------+
> +| id_block   | string| none     | base64 encoded ID block                      |
> ++------------+-------+----------+----------------------------------------------+
> +| id_auth    | string| none     | base64 encoded authentication information    |
> ++------------+-------+----------+----------------------------------------------+
> +| auth_key_en| bool  | 0        | auth block contains author key               |
> ++------------+-------+----------+----------------------------------------------+
> +| host_data  | string| none     | host provided data                           |
> ++------------+-------+----------+----------------------------------------------+
> +
> +To launch a SEV-SNP guest
> +
> +# ${QEMU} \
> +    -machine ...,confidential-guest-support=sev0 \
> +    -object sev-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,snp=on
> +
> +To launch a SEV-SNP guest with launch configuration
> +
> +# ${QEMU} \
> +    -machine ...,confidential-guest-support=sev0 \
> +    -object sev-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,snp=on,launch-config=<config>
> +
>  Debugging
>  -----------
>  Since the memory contents of a SEV guest are encrypted, hypervisor access to
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 652be317b8..bdf89fda27 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -749,6 +749,10 @@
>  # @reduced-phys-bits: number of bits in physical addresses that become
>  #                     unavailable when SEV is enabled
>  #
> +# @snp: SEV-SNP is enabled (default: 0)
> +#
> +# @launch-config: launch config file to use
> +#
>  # Since: 2.12
>  ##
>  { 'struct': 'SevGuestProperties',
> @@ -758,6 +762,8 @@
>              '*policy': 'uint32',
>              '*handle': 'uint32',
>              '*cbitpos': 'uint32',
> +            '*snp': 'bool',
> +            '*launch-config': 'str',
>              'reduced-phys-bits': 'uint32' } }
>  
>  ##
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 83df8c09f6..6b238ef969 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -37,6 +37,11 @@
>  #define TYPE_SEV_GUEST "sev-guest"
>  OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
>  
> +struct snp_launch_config {
> +    struct kvm_snp_init init;
> +    struct kvm_sev_snp_launch_start start;
> +    struct kvm_sev_snp_launch_finish finish;
> +};
>  
>  /**
>   * SevGuestState:
> @@ -58,6 +63,8 @@ struct SevGuestState {
>      char *session_file;
>      uint32_t cbitpos;
>      uint32_t reduced_phys_bits;
> +    char *launch_config_file;
> +    bool snp;
>  
>      /* runtime state */
>      uint32_t handle;
> @@ -72,10 +79,13 @@ struct SevGuestState {
>      uint32_t reset_cs;
>      uint32_t reset_ip;
>      bool reset_data_valid;
> +
> +    struct snp_launch_config snp_config;
>  };
>  
>  #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
>  #define DEFAULT_SEV_DEVICE      "/dev/sev"
> +#define DEFAULT_SEV_SNP_POLICY  0x30000
>  
>  #define SEV_INFO_BLOCK_GUID     "00f771de-1a7e-4fcb-890e-68c77e2fb44e"
>  typedef struct __attribute__((__packed__)) SevInfoBlock {
> @@ -298,6 +308,212 @@ sev_guest_set_sev_device(Object *obj, const char *value, Error **errp)
>      sev->sev_device = g_strdup(value);
>  }
>  
> +static void
> +sev_guest_set_snp(Object *obj, bool value, Error **errp)
> +{
> +    SevGuestState *sev = SEV_GUEST(obj);
> +
> +    sev->snp = value;
> +}
> +
> +static bool
> +sev_guest_get_snp(Object *obj, Error **errp)
> +{
> +    SevGuestState *sev = SEV_GUEST(obj);
> +
> +    return sev->snp;
> +}
> +
> +
> +static char *
> +sev_guest_get_launch_config_file(Object *obj, Error **errp)
> +{
> +    SevGuestState *s = SEV_GUEST(obj);
> +
> +    return g_strdup(s->launch_config_file);
> +}
> +
> +static int
> +config_read_uint64(GKeyFile *f, const char *key, uint64_t *value, Error **errp)
> +{
> +    g_autoptr(GError) error = NULL;
> +    g_autofree gchar *str = NULL;
> +    uint64_t res;
> +
> +    str = g_key_file_get_string(f, "SEV-SNP", key, &error);
> +    if (!str) {
> +        /* key not found */
> +        return 0;
> +    }
> +
> +    res = g_ascii_strtoull(str, NULL, 16);
> +    if (res == G_MAXUINT64) {
> +        error_setg(errp, "Failed to convert %s", str);
> +        return 1;
> +    }
> +
> +    *value = res;
> +    return 0;
> +}
> +
> +static int
> +config_read_bool(GKeyFile *f, const char *key, bool *value, Error **errp)
> +{
> +    g_autoptr(GError) error = NULL;
> +    gboolean val;
> +
> +    val = g_key_file_get_boolean(f, "SEV-SNP", key, &error);
> +    if (!val && g_error_matches(error, G_KEY_FILE_ERROR,
> +                                 G_KEY_FILE_ERROR_INVALID_VALUE)) {
> +        error_setg(errp, "%s", error->message);
> +        return 1;
> +    }
> +
> +    *value = val;
> +    return 0;
> +}
> +
> +static int
> +config_read_blob(GKeyFile *f, const char *key, uint8_t *blob, uint32_t len,
> +                 Error **errp)
> +{
> +    g_autoptr(GError) error = NULL;
> +    g_autofree guchar *data = NULL;
> +    g_autofree gchar *base64 = NULL;
> +    gsize size;
> +
> +    base64 = g_key_file_get_string(f, "SEV-SNP", key, &error);
> +    if (!base64) {
> +        /* key not found */
> +        return 0;
> +    }
> +
> +    /* lets decode the value string */
> +    data = g_base64_decode(base64, &size);
> +    if (!data) {
> +        error_setg(errp, "failed to decode '%s'", key);
> +        return 1;
> +    }
> +
> +    /* verify the length */
> +    if (len != size) {
> +        error_setg(errp, "invalid length for key '%s' (expected %d got %ld)",
> +                   key, len, size);
> +        return 1;
> +    }
> +
> +    memcpy(blob, data, size);
> +    return 0;
> +}
> +
> +static int
> +snp_parse_launch_config(SevGuestState *sev, const char *file, Error **errp)
> +{
> +    g_autoptr(GError) error = NULL;
> +    g_autoptr(GKeyFile) key_file = g_key_file_new();
> +    struct kvm_sev_snp_launch_start *start = &sev->snp_config.start;
> +    struct kvm_snp_init *init = &sev->snp_config.init;
> +    struct kvm_sev_snp_launch_finish *finish = &sev->snp_config.finish;
> +    uint8_t *id_block = NULL, *id_auth = NULL;
> +
> +    if (!g_key_file_load_from_file(key_file, file, G_KEY_FILE_NONE, &error)) {
> +        error_setg(errp, "Error loading config file: %s", error->message);
> +        return 1;
> +    }
> +
> +    /* Check the group first */
> +    if (!g_key_file_has_group(key_file, "SEV-SNP")) {
> +        error_setg(errp, "Error parsing config file, group SEV-SNP not found");
> +        return 1;
> +    }
> +
> +    /* Get the init_flags used in KVM_SNP_INIT */
> +    if (config_read_uint64(key_file, "init_flags",
> +                           (uint64_t *)&init->flags, errp)) {
> +        goto err;
> +    }
> +
> +    /* Get the policy used in LAUNCH_START */
> +    if (config_read_uint64(key_file, "policy",
> +                           (uint64_t *)&start->policy, errp)) {
> +        goto err;
> +    }
> +
> +    /* Get IMI_EN used in LAUNCH_START */
> +    if (config_read_bool(key_file, "imi_en", (bool *)&start->imi_en, errp)) {
> +        goto err;
> +    }
> +
> +    /* Get MA_EN used in LAUNCH_START */
> +    if (config_read_bool(key_file, "imi_en", (bool *)&start->ma_en, errp)) {
> +        goto err;
> +    }
> +
> +    /* Get GOSVW used in LAUNCH_START */
> +    if (config_read_blob(key_file, "gosvw", (uint8_t *)&start->gosvw,
> +                         sizeof(start->gosvw), errp)) {
> +        goto err;
> +    }
> +
> +    /* Get ID block used in LAUNCH_FINISH */
> +    if (g_key_file_has_key(key_file, "SEV-SNP", "id_block", &error)) {
> +
> +        id_block = g_malloc(KVM_SEV_SNP_ID_BLOCK_SIZE);
> +
> +        if (config_read_blob(key_file, "id_block", id_block,
> +                             KVM_SEV_SNP_ID_BLOCK_SIZE, errp)) {
> +            goto err;
> +        }
> +
> +        finish->id_block_uaddr = (unsigned long)id_block;
> +        finish->id_block_en = 1;
> +    }
> +
> +    /* Get authentication block used in LAUNCH_FINISH */
> +    if (g_key_file_has_key(key_file, "SEV-SNP", "id_auth", &error)) {
> +
> +        id_auth = g_malloc(KVM_SEV_SNP_ID_AUTH_SIZE);
> +
> +        if (config_read_blob(key_file, "auth_block", id_auth,
> +                             KVM_SEV_SNP_ID_AUTH_SIZE, errp)) {
> +            goto err;
> +        }
> +
> +        finish->id_auth_uaddr = (unsigned long)id_auth;
> +
> +        /* Get AUTH_KEY_EN used in LAUNCH_FINISH */
> +        if (config_read_bool(key_file, "auth_key_en",
> +                             (bool *)&finish->auth_key_en, errp)) {
> +            goto err;
> +        }
> +    }
> +
> +    /* Get host_data used in LAUNCH_FINISH */
> +    if (config_read_blob(key_file, "host_data", (uint8_t *)&finish->host_data,
> +                         sizeof(finish->host_data), errp)) {
> +        goto err;
> +    }
> +
> +    return 0;
> +
> +err:
> +    g_free(id_block);
> +    g_free(id_auth);
> +    return 1;
> +}
> +
> +static void
> +sev_guest_set_launch_config_file(Object *obj, const char *value, Error **errp)
> +{
> +    SevGuestState *s = SEV_GUEST(obj);
> +
> +    if (snp_parse_launch_config(s, value, errp)) {
> +        return;
> +    }
> +
> +    s->launch_config_file = g_strdup(value);
> +}
> +
>  static void
>  sev_guest_class_init(ObjectClass *oc, void *data)
>  {
> @@ -316,6 +532,16 @@ sev_guest_class_init(ObjectClass *oc, void *data)
>                                    sev_guest_set_session_file);
>      object_class_property_set_description(oc, "session-file",
>              "guest owners session parameters (encoded with base64)");
> +    object_class_property_add_bool(oc, "snp",
> +                                   sev_guest_get_snp,
> +                                   sev_guest_set_snp);
> +    object_class_property_set_description(oc, "snp",
> +            "enable SEV-SNP support");
> +    object_class_property_add_str(oc, "launch-config",
> +                                  sev_guest_get_launch_config_file,
> +                                  sev_guest_set_launch_config_file);
> +    object_class_property_set_description(oc, "launch-config",
> +            "the file provides the SEV-SNP guest launch parameters");
>  }
>  
>  static void
> @@ -325,6 +551,7 @@ sev_guest_instance_init(Object *obj)
>  
>      sev->sev_device = g_strdup(DEFAULT_SEV_DEVICE);
>      sev->policy = DEFAULT_GUEST_POLICY;
> +    sev->snp_config.start.policy = DEFAULT_SEV_SNP_POLICY;
>      object_property_add_uint32_ptr(obj, "policy", &sev->policy,
>                                     OBJ_PROP_FLAG_READWRITE);
>      object_property_add_uint32_ptr(obj, "handle", &sev->handle,
> -- 
> 2.17.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


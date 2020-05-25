Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A2C1E0BE7
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 12:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389789AbgEYKhG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 25 May 2020 06:37:06 -0400
Received: from 8.mo6.mail-out.ovh.net ([178.33.42.204]:37835 "EHLO
        8.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389165AbgEYKhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 06:37:05 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 May 2020 06:37:02 EDT
Received: from player787.ha.ovh.net (unknown [10.108.54.36])
        by mo6.mail-out.ovh.net (Postfix) with ESMTP id 59ADD20DC42
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 12:27:19 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player787.ha.ovh.net (Postfix) with ESMTPSA id B759F12DA05A1;
        Mon, 25 May 2020 10:27:01 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-95G001d606502f-2cb2-4bc0-ba2d-7477a65ac1ca,22A89661A4361147AF88D80C9EA00EFFECB1F326) smtp.auth=groug@kaod.org
Date:   Mon, 25 May 2020 12:26:55 +0200
From:   Greg Kurz <groug@kaod.org>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [RFC v2 11/18] guest memory protection: Handle memory encrption
 via interface
Message-ID: <20200525122655.0488cc3d@bahia.lan>
In-Reply-To: <20200521034304.340040-12-david@gibson.dropbear.id.au>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
        <20200521034304.340040-12-david@gibson.dropbear.id.au>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 11351041387843197414
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedruddvtddgvdekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfesthhqredtredtjeenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepueekjeekiefffedtveeukedvteejgeeivefhgfejgfdtleduvdfgfeelkeeuveeunecukfhppedtrddtrddtrddtpdekvddrvdehfedrvddtkedrvdegkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejkeejrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


s/encrption/encryption

On Thu, 21 May 2020 13:42:57 +1000
David Gibson <david@gibson.dropbear.id.au> wrote:

> At the moment AMD SEV sets a special function pointer, plus an opaque
> handle in KVMState to let things know how to encrypt guest memory.
> 
> Now that we have a QOM interface for handling things related to guest
> memory protection, use a QOM method on that interface, rather than a bare
> function pointer for this.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  accel/kvm/kvm-all.c                    | 23 +++----
>  accel/kvm/sev-stub.c                   |  5 --
>  include/exec/guest-memory-protection.h |  2 +
>  include/sysemu/sev.h                   |  6 +-
>  target/i386/sev.c                      | 84 ++++++++++++++------------
>  5 files changed, 63 insertions(+), 57 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index d06cc04079..40997de38c 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -45,6 +45,7 @@
>  #include "qapi/qapi-types-common.h"
>  #include "qapi/qapi-visit-common.h"
>  #include "sysemu/reset.h"
> +#include "exec/guest-memory-protection.h"
>  
>  #include "hw/boards.h"
>  
> @@ -119,8 +120,7 @@ struct KVMState
>      QLIST_HEAD(, KVMParkedVcpu) kvm_parked_vcpus;
>  
>      /* memory encryption */
> -    void *memcrypt_handle;
> -    int (*memcrypt_encrypt_data)(void *handle, uint8_t *ptr, uint64_t len);
> +    GuestMemoryProtection *guest_memory_protection;
>  
>      /* For "info mtree -f" to tell if an MR is registered in KVM */
>      int nr_as;
> @@ -172,7 +172,7 @@ int kvm_get_max_memslots(void)
>  
>  bool kvm_memcrypt_enabled(void)
>  {
> -    if (kvm_state && kvm_state->memcrypt_handle) {
> +    if (kvm_state && kvm_state->guest_memory_protection) {
>          return true;
>      }
>  
> @@ -181,10 +181,13 @@ bool kvm_memcrypt_enabled(void)
>  
>  int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
>  {
> -    if (kvm_state->memcrypt_handle &&
> -        kvm_state->memcrypt_encrypt_data) {
> -        return kvm_state->memcrypt_encrypt_data(kvm_state->memcrypt_handle,
> -                                              ptr, len);
> +    GuestMemoryProtection *gmpo = kvm_state->guest_memory_protection;
> +
> +    if (gmpo) {
> +        GuestMemoryProtectionClass *gmpc =
> +            GUEST_MEMORY_PROTECTION_GET_CLASS(gmpo);
> +
> +        return gmpc->encrypt_data(gmpo, ptr, len);
>      }
>  
>      return 1;
> @@ -2101,13 +2104,11 @@ static int kvm_init(MachineState *ms)
>       * encryption context.
>       */
>      if (ms->memory_encryption) {
> -        kvm_state->memcrypt_handle = sev_guest_init(ms->memory_encryption);
> -        if (!kvm_state->memcrypt_handle) {
> +        kvm_state->guest_memory_protection = sev_guest_init(ms->memory_encryption);
> +        if (!kvm_state->guest_memory_protection) {
>              ret = -1;
>              goto err;
>          }
> -
> -        kvm_state->memcrypt_encrypt_data = sev_encrypt_data;
>      }
>  
>      ret = kvm_arch_init(ms, s);
> diff --git a/accel/kvm/sev-stub.c b/accel/kvm/sev-stub.c
> index 4f97452585..4a5cc5569e 100644
> --- a/accel/kvm/sev-stub.c
> +++ b/accel/kvm/sev-stub.c
> @@ -15,11 +15,6 @@
>  #include "qemu-common.h"
>  #include "sysemu/sev.h"
>  
> -int sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
> -{
> -    abort();
> -}
> -
>  void *sev_guest_init(const char *id)
>  {
>      return NULL;

This requires some extra care:

accel/kvm/sev-stub.c:18:7: error: conflicting types for ‘sev_guest_init’
 void *sev_guest_init(const char *id)
       ^~~~~~~~~~~~~~
In file included from accel/kvm/sev-stub.c:16:0:
include/sysemu/sev.h:21:24: note: previous declaration of ‘sev_guest_init’ was here
 GuestMemoryProtection *sev_guest_init(const char *id);
                        ^~~~~~~~~~~~~~
rules.mak:69: recipe for target 'accel/kvm/sev-stub.o' failed

> diff --git a/include/exec/guest-memory-protection.h b/include/exec/guest-memory-protection.h
> index 38e9b01667..eb712a5804 100644
> --- a/include/exec/guest-memory-protection.h
> +++ b/include/exec/guest-memory-protection.h
> @@ -30,6 +30,8 @@ typedef struct GuestMemoryProtection GuestMemoryProtection;
>  
>  typedef struct GuestMemoryProtectionClass {
>      InterfaceClass parent;
> +
> +    int (*encrypt_data)(GuestMemoryProtection *, uint8_t *, uint64_t);
>  } GuestMemoryProtectionClass;
>  
>  #endif /* QEMU_GUEST_MEMORY_PROTECTION_H */
> diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
> index 98c1ec8d38..7735a7942e 100644
> --- a/include/sysemu/sev.h
> +++ b/include/sysemu/sev.h
> @@ -16,6 +16,8 @@
>  
>  #include "sysemu/kvm.h"
>  
> -void *sev_guest_init(const char *id);
> -int sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len);
> +typedef struct GuestMemoryProtection GuestMemoryProtection;
> +
> +GuestMemoryProtection *sev_guest_init(const char *id);
> +
>  #endif
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index d273174ad3..986c2fee51 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -28,6 +28,7 @@
>  #include "sysemu/runstate.h"
>  #include "trace.h"
>  #include "migration/blocker.h"
> +#include "exec/guest-memory-protection.h"
>  
>  #define TYPE_SEV_GUEST "sev-guest"
>  #define SEV_GUEST(obj)                                          \
> @@ -281,26 +282,6 @@ sev_guest_set_sev_device(Object *obj, const char *value, Error **errp)
>      sev->sev_device = g_strdup(value);
>  }
>  
> -static void
> -sev_guest_class_init(ObjectClass *oc, void *data)
> -{
> -    object_class_property_add_str(oc, "sev-device",
> -                                  sev_guest_get_sev_device,
> -                                  sev_guest_set_sev_device);
> -    object_class_property_set_description(oc, "sev-device",
> -            "SEV device to use");
> -    object_class_property_add_str(oc, "dh-cert-file",
> -                                  sev_guest_get_dh_cert_file,
> -                                  sev_guest_set_dh_cert_file);
> -    object_class_property_set_description(oc, "dh-cert-file",
> -            "guest owners DH certificate (encoded with base64)");
> -    object_class_property_add_str(oc, "session-file",
> -                                  sev_guest_get_session_file,
> -                                  sev_guest_set_session_file);
> -    object_class_property_set_description(oc, "session-file",
> -            "guest owners session parameters (encoded with base64)");
> -}
> -
>  static void
>  sev_guest_instance_init(Object *obj)
>  {
> @@ -319,20 +300,6 @@ sev_guest_instance_init(Object *obj)
>                                     OBJ_PROP_FLAG_READWRITE);
>  }
>  
> -/* sev guest info */
> -static const TypeInfo sev_guest_info = {
> -    .parent = TYPE_OBJECT,
> -    .name = TYPE_SEV_GUEST,
> -    .instance_size = sizeof(SevGuestState),
> -    .instance_finalize = sev_guest_finalize,
> -    .class_init = sev_guest_class_init,
> -    .instance_init = sev_guest_instance_init,
> -    .interfaces = (InterfaceInfo[]) {
> -        { TYPE_USER_CREATABLE },
> -        { }
> -    }
> -};
> -
>  static SevGuestState *
>  lookup_sev_guest_info(const char *id)
>  {
> @@ -670,7 +637,7 @@ sev_vm_state_change(void *opaque, int running, RunState state)
>      }
>  }
>  
> -void *
> +GuestMemoryProtection *
>  sev_guest_init(const char *id)
>  {
>      SevGuestState *sev;
> @@ -748,16 +715,16 @@ sev_guest_init(const char *id)
>      qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
>      qemu_add_vm_change_state_handler(sev_vm_state_change, sev);
>  
> -    return sev;
> +    return GUEST_MEMORY_PROTECTION(sev);
>  err:
>      sev_guest = NULL;
>      return NULL;
>  }
>  
> -int
> -sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
> +static int
> +sev_encrypt_data(GuestMemoryProtection *opaque, uint8_t *ptr, uint64_t len)
>  {
> -    SevGuestState *sev = handle;
> +    SevGuestState *sev = SEV_GUEST(opaque);
>  
>      assert(sev);
>  
> @@ -769,6 +736,45 @@ sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
>      return 0;
>  }
>  
> +static void
> +sev_guest_class_init(ObjectClass *oc, void *data)
> +{
> +    GuestMemoryProtectionClass *gmpc = GUEST_MEMORY_PROTECTION_CLASS(oc);
> +
> +    object_class_property_add_str(oc, "sev-device",
> +                                  sev_guest_get_sev_device,
> +                                  sev_guest_set_sev_device);
> +    object_class_property_set_description(oc, "sev-device",
> +        "SEV device to use");
> +    object_class_property_add_str(oc, "dh-cert-file",
> +                                  sev_guest_get_dh_cert_file,
> +                                  sev_guest_set_dh_cert_file);
> +    object_class_property_set_description(oc, "dh-cert-file",
> +        "guest owners DH certificate (encoded with base64)");
> +    object_class_property_add_str(oc, "session-file",
> +                                  sev_guest_get_session_file,
> +                                  sev_guest_set_session_file);
> +    object_class_property_set_description(oc, "session-file",
> +        "guest owners session parameters (encoded with base64)");
> +
> +    gmpc->encrypt_data = sev_encrypt_data;
> +}
> +
> +/* sev guest info */
> +static const TypeInfo sev_guest_info = {
> +    .parent = TYPE_OBJECT,
> +    .name = TYPE_SEV_GUEST,
> +    .instance_size = sizeof(SevGuestState),
> +    .instance_finalize = sev_guest_finalize,
> +    .class_init = sev_guest_class_init,
> +    .instance_init = sev_guest_instance_init,
> +    .interfaces = (InterfaceInfo[]) {
> +        { TYPE_GUEST_MEMORY_PROTECTION },
> +        { TYPE_USER_CREATABLE },
> +        { }
> +    }
> +};
> +
>  static void
>  sev_register_types(void)
>  {


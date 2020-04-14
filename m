Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFD91A800D
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 16:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404117AbgDNOnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 10:43:32 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30033 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403978AbgDNOn3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 10:43:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586875407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TCQsKiBpTP+4gDkO61IkKBIdivNFECjdnvdrNPVMnYU=;
        b=NBY/IyZo0jFtgU7KCz/cXuh5W+0slvmxGGz2IliqAhxaSWVVEWIiyt2MSe4e7lIX1z/yin
        5pnf+1mheog5seX0B7n04qdD9dj3CeLKzMX430Opk+zRn7C6nP8Y8oBs4atvF0OCA3Ten4
        Oxp5E943QsOGIz1BpevDq0ewsrVjH90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-lUoDxhRQMQSosFfCl7Mm-Q-1; Tue, 14 Apr 2020 10:43:25 -0400
X-MC-Unique: lUoDxhRQMQSosFfCl7Mm-Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4DEA1088381;
        Tue, 14 Apr 2020 14:43:23 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-15.gru2.redhat.com [10.97.116.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BA645D9CD;
        Tue, 14 Apr 2020 14:43:11 +0000 (UTC)
Subject: Re: [PATCH 09/10] KVM: selftests: Make set_memory_region_test common
 to all architectures
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
 <20200410231707.7128-10-sean.j.christopherson@intel.com>
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
Message-ID: <6a58ddfc-2d1d-63fb-9910-0ba4a6a81862@redhat.com>
Date:   Tue, 14 Apr 2020 11:43:09 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200410231707.7128-10-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 4/10/20 8:17 PM, Sean Christopherson wrote:
> Make set_memory_region_test available on all architectures by wrapping
> the bits that are x86-specific in ifdefs.  All architectures can do
> no-harm testing of running with zero memslots, and a future testcase
> to create the maximum number of memslots will also be architecture
> agnostic.

I got this series successfully compiled in aarch64 and s390x. However=20
the zero memslot test fails on both arches on vcpu_run().

The machines I borrowed got RHEL-8.1.0 installed (kernel 4.18.0-147).=20
Perhaps I am using a too old kernel? Anyway, trying to get at least an=20
aarch64 box with newer kernel to double check.

The error on aarch64:

Testing KVM_RUN with zero added memory regions
=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
 =A0 lib/kvm_util.c:1179: ret =3D=3D 0
 =A0 pid=3D83625 tid=3D83625 - Exec format error
 =A0=A0=A0=A0 1=A0=A0=A0 0x000000000040114f: test_zero_memory_regions at=20
set_memory_region_test.c:313
 =A0=A0=A0=A0 2=A0=A0=A0 =A0(inlined by) main at set_memory_region_test.c=
:383
 =A0=A0=A0=A0 3=A0=A0=A0 0x0000ffff92e70d63: ?? ??:0
 =A0=A0=A0=A0 4=A0=A0=A0 0x0000000000401367: _start at :?
 =A0 KVM_RUN IOCTL failed, rc: -1 errno: 8

And on s390x:

Testing KVM_RUN with zero added memory regions
=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
 =A0 lib/kvm_util.c:1179: ret =3D=3D 0
 =A0 pid=3D41263 tid=3D-1 - Invalid argument
 =A0=A0=A0=A0 1=A0=A0=A0 0x00000000010029b5: vcpu_run at kvm_util.c:1178
 =A0=A0=A0=A0 2=A0=A0=A0 0x0000000001001563: test_zero_memory_regions at=20
set_memory_region_test.c:313
 =A0=A0=A0=A0 3=A0=A0=A0 =A0(inlined by) main at set_memory_region_test.c=
:383
 =A0=A0=A0=A0 4=A0=A0=A0 0x000003ffb80a3611: ?? ??:0
 =A0=A0=A0=A0 5=A0=A0=A0 0x00000000010017bd: .annobin_init.c.hot at crt1.=
o:?
 =A0=A0=A0=A0 6=A0=A0=A0 0xffffffffffffffff: ?? ??:0
 =A0 KVM_RUN IOCTL failed, rc: -1 errno: 14

Thanks,

Wainer

>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   tools/testing/selftests/kvm/.gitignore              |  2 +-
>   tools/testing/selftests/kvm/Makefile                |  4 +++-
>   .../kvm/{x86_64 =3D> }/set_memory_region_test.c       | 13 ++++++++++=
++-
>   3 files changed, 16 insertions(+), 3 deletions(-)
>   rename tools/testing/selftests/kvm/{x86_64 =3D> }/set_memory_region_t=
est.c (97%)
>
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/sel=
ftests/kvm/.gitignore
> index 16877c3daabf..5947cc119abc 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -6,7 +6,6 @@
>   /x86_64/hyperv_cpuid
>   /x86_64/mmio_warning_test
>   /x86_64/platform_info_test
> -/x86_64/set_memory_region_test
>   /x86_64/set_sregs_test
>   /x86_64/smm_test
>   /x86_64/state_test
> @@ -21,4 +20,5 @@
>   /demand_paging_test
>   /dirty_log_test
>   /kvm_create_max_vcpus
> +/set_memory_region_test
>   /steal_time
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selft=
ests/kvm/Makefile
> index 712a2ddd2a27..7af62030c12f 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -17,7 +17,6 @@ TEST_GEN_PROGS_x86_64 +=3D x86_64/evmcs_test
>   TEST_GEN_PROGS_x86_64 +=3D x86_64/hyperv_cpuid
>   TEST_GEN_PROGS_x86_64 +=3D x86_64/mmio_warning_test
>   TEST_GEN_PROGS_x86_64 +=3D x86_64/platform_info_test
> -TEST_GEN_PROGS_x86_64 +=3D x86_64/set_memory_region_test
>   TEST_GEN_PROGS_x86_64 +=3D x86_64/set_sregs_test
>   TEST_GEN_PROGS_x86_64 +=3D x86_64/smm_test
>   TEST_GEN_PROGS_x86_64 +=3D x86_64/state_test
> @@ -32,12 +31,14 @@ TEST_GEN_PROGS_x86_64 +=3D clear_dirty_log_test
>   TEST_GEN_PROGS_x86_64 +=3D demand_paging_test
>   TEST_GEN_PROGS_x86_64 +=3D dirty_log_test
>   TEST_GEN_PROGS_x86_64 +=3D kvm_create_max_vcpus
> +TEST_GEN_PROGS_x86_64 +=3D set_memory_region_test
>   TEST_GEN_PROGS_x86_64 +=3D steal_time
>  =20
>   TEST_GEN_PROGS_aarch64 +=3D clear_dirty_log_test
>   TEST_GEN_PROGS_aarch64 +=3D demand_paging_test
>   TEST_GEN_PROGS_aarch64 +=3D dirty_log_test
>   TEST_GEN_PROGS_aarch64 +=3D kvm_create_max_vcpus
> +TEST_GEN_PROGS_aarch64 +=3D set_memory_region_test
>   TEST_GEN_PROGS_aarch64 +=3D steal_time
>  =20
>   TEST_GEN_PROGS_s390x =3D s390x/memop
> @@ -46,6 +47,7 @@ TEST_GEN_PROGS_s390x +=3D s390x/sync_regs_test
>   TEST_GEN_PROGS_s390x +=3D demand_paging_test
>   TEST_GEN_PROGS_s390x +=3D dirty_log_test
>   TEST_GEN_PROGS_s390x +=3D kvm_create_max_vcpus
> +TEST_GEN_PROGS_s390x +=3D set_memory_region_test
>  =20
>   TEST_GEN_PROGS +=3D $(TEST_GEN_PROGS_$(UNAME_M))
>   LIBKVM +=3D $(LIBKVM_$(UNAME_M))
> diff --git a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.=
c b/tools/testing/selftests/kvm/set_memory_region_test.c
> similarity index 97%
> rename from tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
> rename to tools/testing/selftests/kvm/set_memory_region_test.c
> index c274ce6b4ba2..0f36941ebb96 100644
> --- a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
> +++ b/tools/testing/selftests/kvm/set_memory_region_test.c
> @@ -18,6 +18,7 @@
>  =20
>   #define VCPU_ID 0
>  =20
> +#ifdef __x86_64__
>   /*
>    * Somewhat arbitrary location and slot, intended to not overlap anyt=
hing.  The
>    * location and size are specifically 2mb sized/aligned so that the i=
nitial
> @@ -288,6 +289,7 @@ static void test_delete_memory_region(void)
>  =20
>   	kvm_vm_free(vm);
>   }
> +#endif /* __x86_64__ */
>  =20
>   static void test_zero_memory_regions(void)
>   {
> @@ -299,13 +301,18 @@ static void test_zero_memory_regions(void)
>   	vm =3D vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
>   	vm_vcpu_add(vm, VCPU_ID);
>  =20
> +#ifdef __x86_64__
>   	TEST_ASSERT(!ioctl(vm_get_fd(vm), KVM_SET_NR_MMU_PAGES, 64),
>   		    "KVM_SET_NR_MMU_PAGES failed, errno =3D %d\n", errno);
> -
> +#endif
>   	vcpu_run(vm, VCPU_ID);
>  =20
>   	run =3D vcpu_state(vm, VCPU_ID);
> +#ifdef __x86_64__
>   	TEST_ASSERT(run->exit_reason =3D=3D KVM_EXIT_INTERNAL_ERROR,
> +#else
> +	TEST_ASSERT(run->exit_reason !=3D KVM_EXIT_UNKNOWN,
> +#endif
>   		    "Unexpected exit_reason =3D %u\n", run->exit_reason);
>  =20
>   	kvm_vm_free(vm);
> @@ -313,13 +320,16 @@ static void test_zero_memory_regions(void)
>  =20
>   int main(int argc, char *argv[])
>   {
> +#ifdef __x86_64__
>   	int i, loops;
> +#endif
>  =20
>   	/* Tell stdout not to buffer its content */
>   	setbuf(stdout, NULL);
>  =20
>   	test_zero_memory_regions();
>  =20
> +#ifdef __x86_64__
>   	if (argc > 1)
>   		loops =3D atoi(argv[1]);
>   	else
> @@ -332,6 +342,7 @@ int main(int argc, char *argv[])
>   	pr_info("Testing DELETE of in-use region, %d loops\n", loops);
>   	for (i =3D 0; i < loops; i++)
>   		test_delete_memory_region();
> +#endif
>  =20
>   	return 0;
>   }


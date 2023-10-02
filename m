Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F7C7B5940
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 19:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238537AbjJBQ77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 12:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238453AbjJBQ76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 12:59:58 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88681D7;
        Mon,  2 Oct 2023 09:59:53 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RznDn3tWYz67V3m;
        Tue,  3 Oct 2023 00:57:13 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Mon, 2 Oct
 2023 17:59:50 +0100
Date:   Mon, 2 Oct 2023 17:59:50 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Lukas Wunner <lukas@wunner.de>
CC:     Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        <linux-pci@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linuxarm@huawei.com>, David Box <david.e.box@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 05/12] crypto: akcipher - Support more than one
 signature encoding
Message-ID: <20231002175950.0000541d@Huawei.com>
In-Reply-To: <f4a63091203d09e275c3df983692b630ffca4bca.1695921657.git.lukas@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
        <f4a63091203d09e275c3df983692b630ffca4bca.1695921657.git.lukas@wunner.de>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Sep 2023 19:32:35 +0200
Lukas Wunner <lukas@wunner.de> wrote:

> Currently only a single default signature encoding is supported per
> akcipher.
> 
> A subsequent commit will allow a second encoding for ecdsa, namely P1363
> alternatively to X9.62.
> 
> To accommodate for that, amend struct akcipher_request and struct
> crypto_akcipher_sync_data to store the desired signature encoding for
> verify and sign ops.
> 
> Amend akcipher_request_set_crypt(), crypto_sig_verify() and
> crypto_sig_sign() with an additional parameter which specifies the
> desired signature encoding.  Adjust all callers.
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  crypto/akcipher.c                   |  2 +-
>  crypto/asymmetric_keys/public_key.c |  4 ++--
>  crypto/internal.h                   |  1 +
>  crypto/rsa-pkcs1pad.c               | 11 +++++++----
>  crypto/sig.c                        |  6 ++++--
>  crypto/testmgr.c                    |  8 +++++---
>  crypto/testmgr.h                    |  1 +
>  include/crypto/akcipher.h           | 10 +++++++++-
>  include/crypto/sig.h                |  6 ++++--
>  9 files changed, 34 insertions(+), 15 deletions(-)
> 
> diff --git a/crypto/akcipher.c b/crypto/akcipher.c
> index 52813f0b19e4..88501c0886d2 100644
> --- a/crypto/akcipher.c
> +++ b/crypto/akcipher.c
> @@ -221,7 +221,7 @@ int crypto_akcipher_sync_prep(struct crypto_akcipher_sync_data *data)
>  	sg = &data->sg;
>  	sg_init_one(sg, buf, mlen);
>  	akcipher_request_set_crypt(req, sg, data->dst ? sg : NULL,
> -				   data->slen, data->dlen);
> +				   data->slen, data->dlen, data->enc);
>  
>  	crypto_init_wait(&data->cwait);
>  	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> index abeecb8329b3..7f96e8e501db 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -354,7 +354,7 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
>  		if (!issig)
>  			break;
>  		ret = crypto_sig_sign(sig, in, params->in_len,
> -				      out, params->out_len);
> +				      out, params->out_len, params->encoding);
>  		break;
>  	default:
>  		BUG();
> @@ -438,7 +438,7 @@ int public_key_verify_signature(const struct public_key *pkey,
>  		goto error_free_key;
>  
>  	ret = crypto_sig_verify(tfm, sig->s, sig->s_size,
> -				sig->digest, sig->digest_size);
> +				sig->digest, sig->digest_size, sig->encoding);
>  
>  error_free_key:
>  	kfree_sensitive(key);
> diff --git a/crypto/internal.h b/crypto/internal.h
> index 63e59240d5fb..268315b13ccd 100644
> --- a/crypto/internal.h
> +++ b/crypto/internal.h
> @@ -41,6 +41,7 @@ struct crypto_akcipher_sync_data {
>  	void *dst;
>  	unsigned int slen;
>  	unsigned int dlen;
> +	const char *enc;
>  
>  	struct akcipher_request *req;
>  	struct crypto_wait cwait;
> diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
> index d2e5e104f8cf..5f9313a3b01e 100644
> --- a/crypto/rsa-pkcs1pad.c
> +++ b/crypto/rsa-pkcs1pad.c
> @@ -262,7 +262,8 @@ static int pkcs1pad_encrypt(struct akcipher_request *req)
>  
>  	/* Reuse output buffer */
>  	akcipher_request_set_crypt(&req_ctx->child_req, req_ctx->in_sg,
> -				   req->dst, ctx->key_size - 1, req->dst_len);
> +				   req->dst, ctx->key_size - 1, req->dst_len,
> +				   NULL);
>  
>  	err = crypto_akcipher_encrypt(&req_ctx->child_req);
>  	if (err != -EINPROGRESS && err != -EBUSY)
> @@ -362,7 +363,7 @@ static int pkcs1pad_decrypt(struct akcipher_request *req)
>  	/* Reuse input buffer, output to a new buffer */
>  	akcipher_request_set_crypt(&req_ctx->child_req, req->src,
>  				   req_ctx->out_sg, req->src_len,
> -				   ctx->key_size);
> +				   ctx->key_size, NULL);
>  
>  	err = crypto_akcipher_decrypt(&req_ctx->child_req);
>  	if (err != -EINPROGRESS && err != -EBUSY)
> @@ -419,7 +420,8 @@ static int pkcs1pad_sign(struct akcipher_request *req)
>  
>  	/* Reuse output buffer */
>  	akcipher_request_set_crypt(&req_ctx->child_req, req_ctx->in_sg,
> -				   req->dst, ctx->key_size - 1, req->dst_len);
> +				   req->dst, ctx->key_size - 1, req->dst_len,
> +				   req->enc);
>  
>  	err = crypto_akcipher_decrypt(&req_ctx->child_req);
>  	if (err != -EINPROGRESS && err != -EBUSY)
> @@ -551,7 +553,8 @@ static int pkcs1pad_verify(struct akcipher_request *req)
>  
>  	/* Reuse input buffer, output to a new buffer */
>  	akcipher_request_set_crypt(&req_ctx->child_req, req->src,
> -				   req_ctx->out_sg, sig_size, ctx->key_size);
> +				   req_ctx->out_sg, sig_size, ctx->key_size,
> +				   req->enc);
>  
>  	err = crypto_akcipher_encrypt(&req_ctx->child_req);
>  	if (err != -EINPROGRESS && err != -EBUSY)
> diff --git a/crypto/sig.c b/crypto/sig.c
> index 224c47019297..4fc1a8f865e4 100644
> --- a/crypto/sig.c
> +++ b/crypto/sig.c
> @@ -89,7 +89,7 @@ EXPORT_SYMBOL_GPL(crypto_sig_maxsize);
>  
>  int crypto_sig_sign(struct crypto_sig *tfm,
>  		    const void *src, unsigned int slen,
> -		    void *dst, unsigned int dlen)
> +		    void *dst, unsigned int dlen, const char *enc)
>  {
>  	struct crypto_akcipher **ctx = crypto_sig_ctx(tfm);
>  	struct crypto_akcipher_sync_data data = {
> @@ -98,6 +98,7 @@ int crypto_sig_sign(struct crypto_sig *tfm,
>  		.dst = dst,
>  		.slen = slen,
>  		.dlen = dlen,
> +		.enc = enc,
>  	};
>  
>  	return crypto_akcipher_sync_prep(&data) ?:
> @@ -108,7 +109,7 @@ EXPORT_SYMBOL_GPL(crypto_sig_sign);
>  
>  int crypto_sig_verify(struct crypto_sig *tfm,
>  		      const void *src, unsigned int slen,
> -		      const void *digest, unsigned int dlen)
> +		      const void *digest, unsigned int dlen, const char *enc)
>  {
>  	struct crypto_akcipher **ctx = crypto_sig_ctx(tfm);
>  	struct crypto_akcipher_sync_data data = {
> @@ -116,6 +117,7 @@ int crypto_sig_verify(struct crypto_sig *tfm,
>  		.src = src,
>  		.slen = slen,
>  		.dlen = dlen,
> +		.enc = enc,
>  	};
>  	int err;
>  
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 216878c8bc3d..d5dd715673dd 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -4154,11 +4154,12 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
>  			goto free_all;
>  		memcpy(xbuf[1], c, c_size);
>  		sg_set_buf(&src_tab[2], xbuf[1], c_size);
> -		akcipher_request_set_crypt(req, src_tab, NULL, m_size, c_size);
> +		akcipher_request_set_crypt(req, src_tab, NULL, m_size, c_size,
> +					   vecs->enc);
>  	} else {
>  		sg_init_one(&dst, outbuf_enc, out_len_max);
>  		akcipher_request_set_crypt(req, src_tab, &dst, m_size,
> -					   out_len_max);
> +					   out_len_max, NULL);
>  	}
>  	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>  				      crypto_req_done, &wait);
> @@ -4217,7 +4218,8 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
>  	sg_init_one(&src, xbuf[0], c_size);
>  	sg_init_one(&dst, outbuf_dec, out_len_max);
>  	crypto_init_wait(&wait);
> -	akcipher_request_set_crypt(req, &src, &dst, c_size, out_len_max);
> +	akcipher_request_set_crypt(req, &src, &dst, c_size, out_len_max,
> +				   vecs->enc);
>  
>  	err = crypto_wait_req(vecs->siggen_sigver_test ?
>  			      /* Run asymmetric signature generation */
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index 5ca7a412508f..ad57e7af2e14 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -153,6 +153,7 @@ struct akcipher_testvec {
>  	const unsigned char *params;
>  	const unsigned char *m;
>  	const unsigned char *c;
> +	const char *enc;
>  	unsigned int key_len;
>  	unsigned int param_len;
>  	unsigned int m_size;
> diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
> index 670508f1dca1..00bbec69af3b 100644
> --- a/include/crypto/akcipher.h
> +++ b/include/crypto/akcipher.h
> @@ -30,6 +30,8 @@
>   *		In case of error where the dst sgl size was insufficient,
>   *		it will be updated to the size required for the operation.
>   *		For verify op this is size of digest part in @src.
> + * @enc:	For verify op it's the encoding of the signature part of @src.
> + *		For sign op it's the encoding of the signature in @dst.
>   * @__ctx:	Start of private context data
>   */
>  struct akcipher_request {
> @@ -38,6 +40,7 @@ struct akcipher_request {
>  	struct scatterlist *dst;
>  	unsigned int src_len;
>  	unsigned int dst_len;
> +	const char *enc;
>  	void *__ctx[] CRYPTO_MINALIGN_ATTR;
>  };
>  
> @@ -272,17 +275,22 @@ static inline void akcipher_request_set_callback(struct akcipher_request *req,
>   * @src_len:	size of the src input scatter list to be processed
>   * @dst_len:	size of the dst output scatter list or size of signature
>   *		portion in @src for verify op
> + * @enc:	encoding of signature portion in @src for verify op,
> + *		encoding of signature in @dst for sign op,
> + *		NULL for encrypt and decrypt op
>   */
>  static inline void akcipher_request_set_crypt(struct akcipher_request *req,
>  					      struct scatterlist *src,
>  					      struct scatterlist *dst,
>  					      unsigned int src_len,
> -					      unsigned int dst_len)
> +					      unsigned int dst_len,
> +					      const char *enc)
>  {
>  	req->src = src;
>  	req->dst = dst;
>  	req->src_len = src_len;
>  	req->dst_len = dst_len;
> +	req->enc = enc;
>  }
>  
>  /**
> diff --git a/include/crypto/sig.h b/include/crypto/sig.h
> index 641b4714c448..1df18005c854 100644
> --- a/include/crypto/sig.h
> +++ b/include/crypto/sig.h
> @@ -81,12 +81,13 @@ int crypto_sig_maxsize(struct crypto_sig *tfm);
>   * @slen:	source length
>   * @dst:	destinatino obuffer
>   * @dlen:	destination length
> + * @enc:	signature encoding
>   *
>   * Return: zero on success; error code in case of error
>   */
>  int crypto_sig_sign(struct crypto_sig *tfm,
>  		    const void *src, unsigned int slen,
> -		    void *dst, unsigned int dlen);
> +		    void *dst, unsigned int dlen, const char *enc);
>  
>  /**
>   * crypto_sig_verify() - Invoke signature verification
> @@ -99,12 +100,13 @@ int crypto_sig_sign(struct crypto_sig *tfm,
>   * @slen:	source length
>   * @digest:	digest
>   * @dlen:	digest length
> + * @enc:	signature encoding
>   *
>   * Return: zero on verification success; error code in case of error.
>   */
>  int crypto_sig_verify(struct crypto_sig *tfm,
>  		      const void *src, unsigned int slen,
> -		      const void *digest, unsigned int dlen);
> +		      const void *digest, unsigned int dlen, const char *enc);
>  
>  /**
>   * crypto_sig_set_pubkey() - Invoke set public key operation

